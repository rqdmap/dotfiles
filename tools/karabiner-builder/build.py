from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ModuleNotFoundError as exc:
    raise SystemExit(
        "PyYAML is required. Install it or run this script via `uv run --with pyyaml ...`."
    ) from exc


# --- Slot table: 7 F-keys x 8 modifier tiers = 56 slots ---

# F20 在当前 macOS 键盘链路上存在丢事件，事件槽仅使用 F13–F19
F_KEYS = ["f13", "f14", "f15", "f16", "f17", "f18", "f19"]

EXPECTED_KEYCODES: dict[str, int] = {
    "f13": 0x69,
    "f14": 0x6B,
    "f15": 0x71,
    "f16": 0x6A,
    "f17": 0x40,
    "f18": 0x4F,
    "f19": 0x50,
    "f20": 0x5A,
}

_EVENTS_H_PATHS = [
    Path(
        "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/"
        "Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h"
    ),
    Path(
        "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/"
        "MacOSX.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/"
        "HIToolbox.framework/Versions/A/Headers/Events.h"
    ),
]

KARABINER_MODIFIER_TIERS: list[list[str]] = [
    [],
    ["left_shift"],
    ["left_control"],
    ["left_option"],
    ["left_shift", "left_control"],
    ["left_shift", "left_option"],
    ["left_control", "left_option"],
    ["left_shift", "left_control", "left_option"],
]

SKHD_MODIFIER_TIERS: list[str] = [
    "",
    "shift - ",
    "ctrl - ",
    "alt - ",
    "shift + ctrl - ",
    "shift + alt - ",
    "ctrl + alt - ",
    "shift + ctrl + alt - ",
]

# AeroSpace binding syntax joins modifiers and key with '-'
AEROSPACE_MODIFIER_MAP: dict[str, str] = {
    "left_shift": "shift",
    "right_shift": "shift",
    "left_control": "ctrl",
    "right_control": "ctrl",
    "left_option": "alt",
    "right_option": "alt",
    "left_command": "cmd",
    "right_command": "cmd",
}

# Canonical modifier order for AeroSpace combos
AEROSPACE_MODIFIER_ORDER: list[str] = ["cmd", "ctrl", "alt", "shift"]

MAX_SLOTS = len(F_KEYS) * len(KARABINER_MODIFIER_TIERS)

ALLOWED_MODIFIERS = {
    "command",
    "control",
    "option",
    "shift",
    "fn",
    "caps_lock",
    "left_command",
    "right_command",
    "left_control",
    "right_control",
    "left_option",
    "right_option",
    "left_shift",
    "right_shift",
    "any",
}


# --- Keycode verification ---


def verify_keycodes() -> list[str]:
    header = None
    for p in _EVENTS_H_PATHS:
        if p.exists():
            header = p.read_text(encoding="utf-8", errors="replace")
            break
    if header is None:
        return ["Cannot verify: Events.h not found (install Xcode CommandLineTools)"]

    errors: list[str] = []
    pattern = re.compile(r"kVK_F(\d+)\s*=\s*(0x[0-9A-Fa-f]+)")
    system_codes: dict[str, int] = {}
    for m in pattern.finditer(header):
        num = int(m.group(1))
        if 13 <= num <= 20:
            system_codes[f"f{num}"] = int(m.group(2), 16)

    for fkey, expected in EXPECTED_KEYCODES.items():
        system_val = system_codes.get(fkey)
        if system_val is None:
            errors.append(f"{fkey}: not found in Events.h")
        elif system_val != expected:
            errors.append(
                f"{fkey}: script has 0x{expected:02X}, system has 0x{system_val:02X}"
            )
    return errors


# --- Slot helpers ---


def get_events_start_slot(config: dict[str, Any]) -> int:
    raw = config.get("events_start_slot", 0)
    if not isinstance(raw, int):
        raise ValueError(f"events_start_slot must be an integer, got {raw!r}")
    if raw < 0 or raw >= MAX_SLOTS:
        raise ValueError(f"events_start_slot {raw} out of range (0-{MAX_SLOTS - 1})")
    return raw


def slot_to_karabiner_combo(index: int) -> str:
    if index < 0 or index >= MAX_SLOTS:
        raise ValueError(f"Slot {index} out of range (0-{MAX_SLOTS - 1})")
    tier = index // len(F_KEYS)
    fkey = F_KEYS[index % len(F_KEYS)]
    modifiers = KARABINER_MODIFIER_TIERS[tier]
    if modifiers:
        return " + ".join(modifiers) + " + " + fkey
    return fkey


def slot_to_aerospace_combo(index: int) -> str:
    if index < 0 or index >= MAX_SLOTS:
        raise ValueError(f"Slot {index} out of range (0-{MAX_SLOTS - 1})")
    tier = index // len(F_KEYS)
    fkey = F_KEYS[index % len(F_KEYS)]
    mods = {AEROSPACE_MODIFIER_MAP[m] for m in KARABINER_MODIFIER_TIERS[tier]}
    ordered = [m for m in AEROSPACE_MODIFIER_ORDER if m in mods]
    return "-".join(ordered + [fkey])


def slot_to_skhd_combo(index: int) -> str:
    if index < 0 or index >= MAX_SLOTS:
        raise ValueError(f"Slot {index} out of range (0-{MAX_SLOTS - 1})")
    tier = index // len(F_KEYS)
    fkey = F_KEYS[index % len(F_KEYS)]
    prefix = SKHD_MODIFIER_TIERS[tier]
    return f"{prefix}{fkey}"


def resolve_events(
    raw_events: list[str] | dict[str, str] | None, *, start_slot: int = 0
) -> dict[str, str]:
    if raw_events is None:
        return {}
    if isinstance(raw_events, list):
        remaining = MAX_SLOTS - start_slot
        if len(raw_events) > remaining:
            raise ValueError(
                f"Too many events ({len(raw_events)}), max {remaining} from start slot {start_slot}"
            )
        return {
            name: slot_to_karabiner_combo(i + start_slot)
            for i, name in enumerate(raw_events)
        }
    return raw_events


# --- Karabiner combo parsing ---


def parse_combo(combo: str, *, is_from: bool = False) -> dict[str, Any]:
    tokens = [token.strip() for token in combo.split("+") if token.strip()]
    if not tokens:
        raise ValueError(f"Empty combo: {combo!r}")

    result: dict[str, Any] = {}
    modifiers = tokens[:-1]

    invalid = [m for m in modifiers if m not in ALLOWED_MODIFIERS]
    if invalid:
        raise ValueError(
            f"Invalid modifier(s) in {combo!r}: {', '.join(invalid)}. "
            "F-keys cannot be used as modifiers."
        )

    if modifiers:
        if is_from:
            result["modifiers"] = {"mandatory": modifiers}
        else:
            result["modifiers"] = modifiers

    last = tokens[-1]
    if last.startswith("button"):
        result["pointing_button"] = last
    else:
        result["key_code"] = last

    return result


def resolve_event(expr: str, events: dict[str, str]) -> str:
    expr = expr.strip()
    if expr.startswith("@"):
        name = expr[1:]
        if name not in events:
            raise KeyError(f"Unknown event alias: {expr}")
        return events[name]
    return expr


def split_map_expr(expr: str) -> tuple[str, str]:
    if "=" not in expr:
        raise ValueError(f"Map expression must contain '=': {expr!r}")
    left, right = expr.split("=", 1)
    return left.strip(), right.strip()


def build_to_list(target: str, events: dict[str, str]) -> list[dict[str, Any]]:
    resolved = resolve_event(target, events)
    return [parse_combo(resolved, is_from=False)]


def normalize_identifier(identifier: str) -> str:
    value = identifier.strip()
    if not value:
        raise ValueError("Empty bundle identifier is not allowed")

    if value.startswith(("re:", "regex:")):
        _, pattern = value.split(":", 1)
        pattern = pattern.strip()
        if not pattern:
            raise ValueError(f"Invalid regex identifier: {identifier!r}")
        return pattern

    escaped = re.escape(value).replace(r"\*", ".*")
    return f"^{escaped}$"


def normalize_identifiers(identifiers: list[str] | None) -> list[str] | None:
    if identifiers is None:
        return None
    return [normalize_identifier(i) for i in identifiers]


def build_conditions(
    raw_conditions: list[dict[str, Any]] | None, app_groups: dict[str, list[str]]
) -> list[dict[str, Any]]:
    conditions: list[dict[str, Any]] = []
    for raw in raw_conditions or []:
        condition = {"type": raw["type"]}

        identifiers = raw.get("identifiers")
        group = raw.get("app_group")
        if identifiers is None and group is not None:
            if group not in app_groups:
                raise KeyError(f"Unknown app_group: {group}")
            identifiers = app_groups[group]

        normalized = normalize_identifiers(identifiers)
        if normalized is not None:
            condition["bundle_identifiers"] = normalized

        conditions.append(condition)

    return conditions


def build_manipulator(
    item: dict[str, Any], events: dict[str, str], app_groups: dict[str, list[str]]
) -> dict[str, Any]:
    manipulator: dict[str, Any] = {
        "description": item["description"],
        "type": item.get("type", "basic"),
    }

    if "map" in item:
        from_expr, to_expr = split_map_expr(item["map"])
        manipulator["from"] = parse_combo(from_expr, is_from=True)
        manipulator["to"] = build_to_list(to_expr, events)
    else:
        legacy_expr = item["description"]
        from_expr, to_expr = split_map_expr(legacy_expr)
        manipulator["from"] = parse_combo(from_expr, is_from=True)
        manipulator["to"] = build_to_list(to_expr, events)

    conditions = build_conditions(item.get("conditions"), app_groups)
    if conditions:
        manipulator["conditions"] = conditions

    return manipulator


# --- Karabiner JSON generation ---


def build_karabiner_document(config: dict[str, Any]) -> dict[str, Any]:
    start_slot = get_events_start_slot(config)
    events = resolve_events(config.get("events"), start_slot=start_slot)
    app_groups = config.get("app_groups", {})

    document = {
        "title": config["title"],
        "version": config.get("version", "1.0.0"),
        "maintainers": config.get("maintainers", []),
        "author": config.get("author", ""),
        "rules": [],
    }

    for raw_rule in config.get("rules", []):
        rule = {
            "description": raw_rule["description"],
            "manipulators": [],
        }
        for raw_item in raw_rule.get("manipulators", []):
            rule["manipulators"].append(build_manipulator(raw_item, events, app_groups))
        document["rules"].append(rule)

    return document


# --- AeroSpace generation ---


def generate_aerospace(config: dict[str, Any]) -> str:
    """Generate AeroSpace mode.main.binding lines from the event bus"""
    raw_events = config.get("events")
    if not isinstance(raw_events, list):
        raise ValueError("aerospace output requires events to be a list (auto-assign mode)")
    start_slot = get_events_start_slot(config)

    actions: dict[str, str] = config.get("actions", {})
    lines: list[str] = []

    for i, name in enumerate(raw_events):
        action = actions.get(name)
        if action is None:
            continue
        combo = slot_to_aerospace_combo(i + start_slot)
        if "'" in action:
            raise ValueError(f"aerospace action for {name!r} contains a single quote: {action!r}")
        lines.append(f"    {combo} = '{action}'")

    return "\n".join(lines) + "\n"


# --- Yabai skhd binding rendering ---


def render_yabai_skhd_bindings_from_events(config: dict[str, Any]) -> str:
    """Render Yabai event-bus actions as skhd bindings"""
    raw_events = config.get("events")
    if not isinstance(raw_events, list):
        raise ValueError("--skhd requires events to be a list (auto-assign mode)")
    start_slot = get_events_start_slot(config)

    actions: dict[str, str] = config.get("actions", {})
    lines: list[str] = []

    for i, name in enumerate(raw_events):
        combo = slot_to_skhd_combo(i + start_slot)
        action = actions.get(name)
        if action is None:
            continue
        lines.append(f"{combo} : {action}")

    return "\n".join(lines) + "\n"


def render_yabai_skhd_bindings_from_direct(config: dict[str, Any]) -> str:
    """Render direct Yabai hotkey definitions as skhd bindings"""
    entries = config.get("skhd", [])
    if not entries:
        return ""

    lines: list[str] = []
    for entry in entries:
        lines.append(f"{entry['hotkey']} : {entry['action']}")

    return "\n".join(lines) + "\n"


def render_yabai_skhd_bindings(config: dict[str, Any]) -> str:
    if config.get("skhd"):
        return render_yabai_skhd_bindings_from_direct(config)
    if config.get("events"):
        return render_yabai_skhd_bindings_from_events(config)
    raise ValueError(
        "Config has neither 'events' nor 'skhd' section for Yabai skhd bindings"
    )


# --- Slot table ---


def print_slot_table(config: dict[str, Any]) -> None:
    start_slot = get_events_start_slot(config)
    events = resolve_events(config.get("events"), start_slot=start_slot)
    if not events:
        print("No events defined.")
        return

    reverse = {combo: name for name, combo in events.items()}

    print(f"{'slot':>4}  {'karabiner combo':<36}  {'aerospace combo':<24}  event")
    print("-" * 100)

    for i in range(MAX_SLOTS):
        k = slot_to_karabiner_combo(i)
        a = slot_to_aerospace_combo(i)
        name = reverse.get(k, "")
        print(f"{i:>4}  {k:<36}  {a:<24}  {name}")


# --- CLI ---


def write_output(content: str, output: Path | None) -> None:
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content, encoding="utf-8")
        print(f"  wrote {output}", file=sys.stderr)
    else:
        sys.stdout.write(content)


def render_karabiner(config: dict[str, Any], *, source_name: str) -> str:
    if not config.get("rules"):
        raise ValueError(f"{source_name}: no 'rules' section for karabiner generation")
    document = build_karabiner_document(config)
    return json.dumps(document, indent=2, ensure_ascii=False) + "\n"


def load_config(
    config_arg: str, *, source_name_override: str | None = None
) -> tuple[str, dict[str, Any]]:
    if config_arg == "-":
        source_name = source_name_override or "<stdin>"
        raw = sys.stdin.read()
    else:
        path = Path(config_arg)
        source_name = source_name_override or str(path)
        raw = path.read_text(encoding="utf-8")

    config = yaml.safe_load(raw)
    if config is None:
        raise ValueError(f"{source_name}: empty YAML document")
    if not isinstance(config, dict):
        raise ValueError(f"{source_name}: top-level YAML must be a mapping")

    return source_name, config


def write_declared_outputs(
    source_name: str,
    config: dict[str, Any],
    karabiner_dir: Path | None,
    skhd_dir: Path | None,
) -> None:
    outputs = config.get("outputs", {})
    if not outputs:
        print(f"  skip {source_name}: no outputs declared", file=sys.stderr)
        return

    if "karabiner" in outputs:
        if karabiner_dir is None:
            raise ValueError(f"{source_name}: karabiner output requires --karabiner-dir")
        payload = render_karabiner(config, source_name=source_name)
        write_output(payload, karabiner_dir / outputs["karabiner"])

    if "skhd" in outputs:
        if skhd_dir is None:
            raise ValueError(f"{source_name}: skhd output requires --skhd-dir")
        content = render_yabai_skhd_bindings(config)
        write_output(content, skhd_dir / outputs["skhd"])

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build Karabiner / AeroSpace configs from YAML"
    )
    parser.add_argument(
        "config",
        nargs="?",
        default=None,
        help="YAML config file path, or '-' to read YAML from stdin",
    )

    mode = parser.add_mutually_exclusive_group()
    mode.add_argument(
        "--karabiner",
        action="store_true",
        help="Generate Karabiner complex_modifications JSON",
    )
    mode.add_argument(
        "--aerospace",
        action="store_true",
        help="Generate AeroSpace [mode.main.binding] fragment",
    )
    mode.add_argument("--skhd", action="store_true", help="Generate skhd config")
    mode.add_argument("--slots", action="store_true", help="Print slot table and exit")
    mode.add_argument(
        "--verify",
        action="store_true",
        help="Verify F-key keycodes against system headers",
    )
    mode.add_argument(
        "--write-outputs",
        action="store_true",
        help="Write all outputs declared by this YAML config",
    )

    parser.add_argument(
        "-o", "--output", type=Path, help="Write output to file instead of stdout"
    )
    parser.add_argument(
        "--source-name",
        help="Logical source name for diagnostics (useful with stdin)",
    )
    parser.add_argument(
        "--karabiner-dir", type=Path, help="Output dir for Karabiner JSON"
    )
    parser.add_argument("--skhd-dir", type=Path, help="Output dir for skhd configs")
    args = parser.parse_args()

    if args.verify:
        errors = verify_keycodes()
        if errors:
            for e in errors:
                print(f"  {e}", file=sys.stderr)
            raise SystemExit(1)
        print("All keycodes verified against system Events.h")
        return

    if args.config is None:
        parser.error("config is required unless using --verify")

    source_name, config = load_config(
        args.config, source_name_override=args.source_name
    )

    if args.slots:
        print_slot_table(config)
        return

    if args.aerospace:
        write_output(generate_aerospace(config), args.output)
        return

    if args.skhd:
        write_output(render_yabai_skhd_bindings(config), args.output)
        return

    if args.karabiner:
        payload = render_karabiner(config, source_name=source_name)
        write_output(payload, args.output)
        return

    if args.write_outputs:
        write_declared_outputs(
            source_name, config, args.karabiner_dir, args.skhd_dir
        )
        return

    parser.error(
        "specify --karabiner, --aerospace, --skhd, --slots, --write-outputs, or --verify"
    )


if __name__ == "__main__":
    main()
