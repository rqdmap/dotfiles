# /// script
# requires-python = ">=3.10"
# dependencies = ["aiohttp>=3.9"]
# ///
"""
IKun Channel Aggregator Proxy

自动聚合 IKunCode 多个逆向/反重力渠道，根据 status.ikuncode.cc 的健康状态
智能路由请求，失败自动 failover 到下一个可用渠道。

用法:
    uv run proxy.py                    # 前台运行
    uv run proxy.py --daemon           # 后台运行 (输出到 proxy.log)
    uv run proxy.py --status           # 查看当前渠道状态

然后将 OpenCode 的 baseURL 改为 http://localhost:8787/v1 即可。
"""

import aiohttp
from aiohttp import web
import asyncio
import json
import time
import logging
import sys
from pathlib import Path

CONFIG_PATH = Path(__file__).parent / "config.json"
LOG_PATH = Path(__file__).parent / "proxy.log"

logger = logging.getLogger("ikun-proxy")


# ─── Channel Health Manager ───────────────────────────────────────────────────


class ChannelManager:
    """管理渠道健康状态，基于 status API 定期刷新。"""

    def __init__(self, config: dict):
        self.channels = config["channels"]
        self.status_url = config["status_url"]
        self.health_interval = config.get("health_check_interval", 60)
        self.channel_status: dict = {}  # slug -> {overall_status, models: {model: {status, latency}}}
        self.last_check = 0.0
        self.request_stats: dict = {}  # slug -> {success: int, fail: int, last_used: float}
        for ch in self.channels:
            self.request_stats[ch["slug"]] = {"success": 0, "fail": 0, "last_used": 0}

    async def refresh_health(self, session: aiohttp.ClientSession):
        """从 status API 获取渠道健康状态（有缓存）。"""
        now = time.time()
        if now - self.last_check < self.health_interval:
            return

        try:
            async with session.get(
                self.status_url,
                headers={"User-Agent": "ikun-proxy/1.0"},
                timeout=aiohttp.ClientTimeout(total=10),
            ) as resp:
                data = await resp.json()
                target_slugs = {ch["slug"] for ch in self.channels}

                for group in data.get("groups", []):
                    if group.get("service") != "cc":
                        continue
                    slug = group.get("channel", "")
                    if slug not in target_slugs:
                        continue

                    models = {}
                    for layer in group.get("layers", []):
                        ls = layer.get("current_status", {})
                        models[layer["request_model"]] = {
                            "status": ls.get("status", 0),
                            "latency": ls.get("latency", 99999),
                        }

                    self.channel_status[slug] = {
                        "overall_status": group.get("current_status", 0),
                        "models": models,
                    }

                self.last_check = now
                summary = {
                    slug: {
                        "status": info["overall_status"],
                        "models": {m: s["status"] for m, s in info["models"].items()},
                    }
                    for slug, info in self.channel_status.items()
                }
                logger.info(
                    f"Health refreshed: {json.dumps(summary, ensure_ascii=False)}"
                )

        except Exception as e:
            logger.warning(f"Health check failed: {e}")

    def get_sorted_channels(self, model: str | None = None) -> list[dict]:
        """
        返回按健康度+延迟排序的渠道列表。
        优先级: available(1) > degraded(2) > unknown(-1) > down(0)
        """
        result = []
        for ch in self.channels:
            slug = ch["slug"]
            info = self.channel_status.get(slug, {})
            overall = info.get("overall_status", -1)

            model_status = -1  # unknown
            model_latency = 99999

            if model and info.get("models"):
                m = info["models"].get(model)
                if m:
                    model_status = m["status"]
                    model_latency = m["latency"]
                else:
                    # 状态页没监控这个模型，用 overall 兜底
                    model_status = overall
            elif info:
                model_status = overall

            result.append(
                {
                    **ch,
                    "model_status": model_status,
                    "model_latency": model_latency,
                    "overall_status": overall,
                }
            )

        def sort_key(c):
            s = c["model_status"]
            priority = {1: 0, 2: 1, -1: 2, 0: 3}.get(s, 4)
            return (priority, c["model_latency"])

        result.sort(key=sort_key)
        return result

    def get_status_report(self) -> dict:
        """返回当前状态报告（给 /status 端点用）。"""
        channels = []
        for ch in self.channels:
            slug = ch["slug"]
            info = self.channel_status.get(slug, {})
            stats = self.request_stats.get(slug, {})
            channels.append(
                {
                    "slug": slug,
                    "overall_status": info.get("overall_status", -1),
                    "models": info.get("models", {}),
                    "requests": stats,
                }
            )
        return {
            "last_health_check": self.last_check,
            "channels": channels,
        }


# ─── Request Proxy ─────────────────────────────────────────────────────────────

RETRIABLE_STATUS = {429, 500, 502, 503, 504}


async def proxy_handler(
    request: web.Request,
    manager: ChannelManager,
    upstream_base: str,
    http_session: aiohttp.ClientSession,
) -> web.StreamResponse:
    """代理请求到最佳渠道，失败自动 failover。"""

    await manager.refresh_health(http_session)

    body = await request.read()

    # 解析 model 和 stream 参数
    model = None
    is_stream = False
    try:
        body_json = json.loads(body)
        model = body_json.get("model")
        is_stream = body_json.get("stream", False)
    except (json.JSONDecodeError, UnicodeDecodeError):
        pass

    # 按健康度排序渠道
    channels = manager.get_sorted_channels(model)

    # 构造上游 URL
    path = request.path
    target_url = f"{upstream_base}{path}"
    if request.query_string:
        target_url += f"?{request.query_string}"

    last_error = None

    for i, ch in enumerate(channels):
        slug = ch["slug"]

        # 构造请求头：透传原始 header，替换 Authorization
        headers = {}
        for k, v in request.headers.items():
            kl = k.lower()
            if kl in (
                "host",
                "transfer-encoding",
                "content-length",
                "authorization",
                "x-api-key",
                "accept-encoding",
            ):
                continue
            headers[k] = v
        headers["Authorization"] = f"Bearer {ch['key']}"
        headers["x-api-key"] = ch["key"]

        remaining = len(channels) - i - 1
        try:
            logger.info(
                f"[{request.method} {path}] -> channel={slug} model={model} "
                f"(health={ch['model_status']} latency={ch['model_latency']}ms, {remaining} fallback(s) left)"
            )

            async with http_session.request(
                method=request.method,
                url=target_url,
                headers=headers,
                data=body if body else None,
                timeout=aiohttp.ClientTimeout(total=300, connect=15),
                auto_decompress=False,
            ) as upstream_resp:
                # 可重试的错误状态码 -> failover
                if upstream_resp.status in RETRIABLE_STATUS:
                    error_body = await upstream_resp.text()
                    logger.warning(
                        f"Channel {slug} returned HTTP {upstream_resp.status}: {error_body[:300]}"
                    )
                    last_error = f"{slug}: HTTP {upstream_resp.status}"
                    manager.request_stats[slug]["fail"] += 1
                    continue

                # 不可重试的客户端错误 (4xx) -> 直接返回
                if upstream_resp.status >= 400:
                    resp_body = await upstream_resp.read()
                    logger.warning(
                        f"Channel {slug} returned non-retriable HTTP {upstream_resp.status}"
                    )
                    return web.Response(
                        status=upstream_resp.status,
                        body=resp_body,
                        content_type=upstream_resp.headers.get(
                            "Content-Type", "application/json"
                        ),
                    )

                # 成功！
                manager.request_stats[slug]["success"] += 1
                manager.request_stats[slug]["last_used"] = time.time()

                if is_stream:
                    # 流式转发
                    resp_headers = {}
                    for k, v in upstream_resp.headers.items():
                        kl = k.lower()
                        if kl not in (
                            "transfer-encoding",
                            "content-length",
                            "content-encoding",
                        ):
                            resp_headers[k] = v

                    response = web.StreamResponse(
                        status=upstream_resp.status,
                        headers=resp_headers,
                    )
                    await response.prepare(request)

                    async for chunk in upstream_resp.content.iter_any():
                        await response.write(chunk)

                    await response.write_eof()
                    logger.info(f"Stream completed via channel {slug}")
                    return response
                else:
                    resp_body = await upstream_resp.read()
                    logger.info(
                        f"Request completed via channel {slug} ({len(resp_body)} bytes)"
                    )
                    return web.Response(
                        status=upstream_resp.status,
                        body=resp_body,
                        content_type=upstream_resp.headers.get(
                            "Content-Type", "application/json"
                        ),
                    )

        except asyncio.TimeoutError:
            logger.warning(f"Channel {slug} timed out")
            last_error = f"{slug}: timeout"
            manager.request_stats[slug]["fail"] += 1
            continue
        except (aiohttp.ClientError, OSError) as e:
            logger.warning(f"Channel {slug} connection error: {e}")
            last_error = f"{slug}: {type(e).__name__}: {e}"
            manager.request_stats[slug]["fail"] += 1
            continue

    # 全部失败
    logger.error(
        f"All channels failed for {request.method} {path}, last error: {last_error}"
    )
    return web.Response(
        status=502,
        body=json.dumps(
            {
                "error": {
                    "message": f"All channels exhausted. Last error: {last_error}",
                    "type": "proxy_error",
                }
            }
        ),
        content_type="application/json",
    )


# ─── Status Endpoint ──────────────────────────────────────────────────────────


async def status_handler(request: web.Request, manager: ChannelManager) -> web.Response:
    """GET /status - 查看当前渠道聚合状态。"""
    report = manager.get_status_report()
    return web.Response(
        body=json.dumps(report, indent=2, ensure_ascii=False, default=str),
        content_type="application/json",
    )


# ─── App Setup ─────────────────────────────────────────────────────────────────


def create_app(config: dict) -> web.Application:
    manager = ChannelManager(config)
    upstream_base = config["upstream_base"].rstrip("/")

    app = web.Application()
    app["_manager"] = manager
    app["_upstream_base"] = upstream_base

    async def on_startup(app_):
        connector = aiohttp.TCPConnector(limit=50, ttl_dns_cache=60)
        app_["_session"] = aiohttp.ClientSession(connector=connector)
        manager.last_check = 0
        await manager.refresh_health(app_["_session"])

    async def on_cleanup(app_):
        await app_["_session"].close()

    async def handle_status(req):
        return await status_handler(req, manager)

    async def handle_proxy(req):
        return await proxy_handler(req, manager, upstream_base, req.app["_session"])

    app.on_startup.append(on_startup)
    app.on_cleanup.append(on_cleanup)
    app.router.add_get("/status", handle_status)
    app.router.add_route("*", "/{path:.*}", handle_proxy)
    return app


# ─── CLI ───────────────────────────────────────────────────────────────────────

STATUS_LABELS = {
    1: "\033[32m UP \033[0m",
    2: "\033[33mDEGR\033[0m",
    0: "\033[31mDOWN\033[0m",
    -1: "\033[90m ?? \033[0m",
}


def print_status():
    """同步获取并打印当前渠道状态。"""
    import urllib.request

    config = json.loads(CONFIG_PATH.read_text())
    url = config["status_url"]

    req = urllib.request.Request(url, headers={"User-Agent": "ikun-proxy/1.0"})
    with urllib.request.urlopen(req, timeout=10) as resp:
        data = json.loads(resp.read())

    slugs = {ch["slug"] for ch in config["channels"]}

    print(f"\n{'Channel':<16} {'Status':<8} {'Models'}")
    print("─" * 70)

    for group in data.get("groups", []):
        if group.get("service") != "cc" or group.get("channel") not in slugs:
            continue
        slug = group["channel"]
        overall = group.get("current_status", -1)
        label = STATUS_LABELS.get(overall, "??")
        models_str = "  ".join(
            f"{l['model']}={STATUS_LABELS.get(l['current_status']['status'], '??')}"
            for l in group.get("layers", [])
        )
        print(f"  {slug:<14} [{label}]  {models_str}")

    print()


def print_help():
    port = 8787
    try:
        port = json.loads(CONFIG_PATH.read_text()).get("listen_port", 8787)
    except Exception:
        pass
    print(f"""
\033[1mIKun Channel Aggregator Proxy\033[0m

  聚合 IKunCode 多个逆向/反重力渠道，自动健康检测 + 故障转移。

\033[1mUsage:\033[0m
  uv run proxy.py              前台运行（看日志）
  uv run proxy.py --daemon     后台运行（日志写入 proxy.log）
  uv run proxy.py --status     查看各渠道实时健康状态
  uv run proxy.py --stop       停止后台进程
  uv run proxy.py --help       显示此帮助

\033[1mConfig:\033[0m
  {CONFIG_PATH}

\033[1mRuntime:\033[0m
  监听地址    http://localhost:{port}
  状态面板    http://localhost:{port}/status
  日志文件    {LOG_PATH}
  PID 文件    {Path(__file__).parent / "proxy.pid"}

\033[1mOpenCode 接入:\033[0m
  将 provider baseURL 改为 http://localhost:{port}/v1，apiKey 任意。
""")


def stop_daemon():
    pid_path = Path(__file__).parent / "proxy.pid"
    if not pid_path.exists():
        print("No PID file found, proxy is not running as daemon.")
        return
    import signal

    pid = int(pid_path.read_text().strip())
    try:
        import os

        os.kill(pid, signal.SIGTERM)
        print(f"Sent SIGTERM to PID {pid}")
        pid_path.unlink()
    except ProcessLookupError:
        print(f"Process {pid} not found, cleaning up stale PID file.")
        pid_path.unlink()


def main():
    if "--help" in sys.argv or "-h" in sys.argv:
        print_help()
        return

    config = json.loads(CONFIG_PATH.read_text())

    if "--status" in sys.argv:
        print_status()
        return

    if "--stop" in sys.argv:
        stop_daemon()
        return

    if "--daemon" in sys.argv:
        import subprocess, os

        args = [sys.executable, __file__]
        log_file = open(LOG_PATH, "a")
        proc = subprocess.Popen(
            args,
            stdout=log_file,
            stderr=log_file,
            start_new_session=True,
        )
        # 写 PID 文件
        pid_path = Path(__file__).parent / "proxy.pid"
        pid_path.write_text(str(proc.pid))
        print(f"Proxy started in background (PID={proc.pid})")
        print(f"  Log: {LOG_PATH}")
        print(f"  PID: {pid_path}")
        print(f"  Stop: kill $(cat {pid_path})")
        return

    # 前台运行
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%H:%M:%S",
    )

    port = config.get("listen_port", 8787)
    slugs = [c["slug"] for c in config["channels"]]
    logger.info(f"IKun Aggregator Proxy starting on :{port}")
    logger.info(f"Channels: {slugs}")
    logger.info(f"Upstream: {config['upstream_base']}")
    logger.info(
        f"Status API: {config['status_url']} (interval={config.get('health_check_interval', 60)}s)"
    )
    logger.info(f"Status page: http://localhost:{port}/status")

    loop = asyncio.new_event_loop()
    app = create_app(config)
    web.run_app(app, host="127.0.0.1", port=port, print=None, loop=loop)


if __name__ == "__main__":
    main()
