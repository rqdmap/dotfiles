#!/bin/bash

# 并发保护:高负载时防止本脚本实例堆积(历史上 top -l 2 变慢会引发 fork 风暴)。
# 锁若存活超过 15s 视为上次异常退出的陈旧锁,强制接管,保证自愈。
LOCK_DIR="/tmp/sketchybar_cpu.lock"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    lock_age=$(( $(date +%s) - $(stat -f %m "$LOCK_DIR" 2>/dev/null || echo 0) ))
    if [ "$lock_age" -lt 15 ]; then
        exit 0
    fi
    rmdir "$LOCK_DIR" 2>/dev/null
    mkdir "$LOCK_DIR" 2>/dev/null || exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

CACHE="/tmp/sketchybar_cpu_total_prev"

CPU_TOTAL=$(python3 - "$CACHE" <<'PYTHON'
import ctypes
import ctypes.util
import os
import sys
import json
import time

libc = ctypes.CDLL(ctypes.util.find_library("c"))

CPU_STATE_USER = 0
CPU_STATE_SYSTEM = 1
CPU_STATE_IDLE = 2
CPU_STATE_NICE = 3
CPU_STATE_MAX = 4

host = libc.mach_host_self()


def sample():
    cpu_count = ctypes.c_uint32()
    cpu_info = ctypes.POINTER(ctypes.c_int)()
    cpu_info_count = ctypes.c_uint32()
    ret = libc.host_processor_info(
        host,
        ctypes.c_int(2),
        ctypes.byref(cpu_count),
        ctypes.byref(cpu_info),
        ctypes.byref(cpu_info_count),
    )
    if ret != 0:
        return None
    n = cpu_count.value
    active = idle = 0
    for i in range(n):
        base = i * CPU_STATE_MAX
        active += (
            cpu_info[base + CPU_STATE_USER]
            + cpu_info[base + CPU_STATE_SYSTEM]
            + cpu_info[base + CPU_STATE_NICE]
        )
        idle += cpu_info[base + CPU_STATE_IDLE]
    return [active, idle]


cur = sample()
if cur is None:
    print("")
    sys.exit(0)

prev = None
cache = sys.argv[1]
if os.path.exists(cache):
    try:
        with open(cache) as f:
            prev = json.load(f)
    except Exception:
        prev = None

# 首次或缓存丢失(/tmp 被清理)时,做一次 0.25s 短采样,避免显示空值。
if not (isinstance(prev, list) and len(prev) == 2):
    time.sleep(0.25)
    prev = cur
    cur = sample() or cur

with open(cache, "w") as f:
    json.dump(cur, f)

d_active = cur[0] - prev[0]
d_idle = cur[1] - prev[1]
total = d_active + d_idle
pct = (100.0 * d_active / total) if total > 0 else 0.0
print(f"{pct:.1f}")
PYTHON
)

if [ -z "$CPU_TOTAL" ]; then
    sketchybar --set cpu label="--" \
                     icon.color="0xfff7768e" \
                     label.color="0xfff7768e" \
                     background.color="0x33f7768e"
    exit 0
fi

CPU_INT=${CPU_TOTAL%.*}
if [ "$CPU_INT" -gt 80 ]; then
    COLOR="0xfff7768e"
    BG_COLOR="0x33f7768e"
elif [ "$CPU_INT" -gt 60 ]; then
    COLOR="0xffe0af68"
    BG_COLOR="0x33e0af68"
elif [ "$CPU_INT" -gt 30 ]; then
    COLOR="0xff7aa2f7"
    BG_COLOR="0x267aa2f7"
else
    COLOR="0xff9ece6a"
    BG_COLOR="0x229ece6a"
fi

sketchybar --set cpu label="${CPU_TOTAL}%" \
                     icon.color="$COLOR" \
                     label.color="$COLOR" \
                     background.color="$BG_COLOR"

