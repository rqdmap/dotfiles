#!/bin/bash

CACHE="/tmp/sketchybar_cpu_prev"

values=$(python3 - "$CACHE" <<'PYTHON'
import ctypes
import ctypes.util
import struct
import os
import sys
import json

libc = ctypes.CDLL(ctypes.util.find_library("c"))

CPU_STATE_USER = 0
CPU_STATE_SYSTEM = 1
CPU_STATE_IDLE = 2
CPU_STATE_NICE = 3
CPU_STATE_MAX = 4

host = libc.mach_host_self()

cpu_count = ctypes.c_uint32()
cpu_info = ctypes.POINTER(ctypes.c_int)()
cpu_info_count = ctypes.c_uint32()

ret = libc.host_processor_info(
    host,
    ctypes.c_int(2),
    ctypes.byref(cpu_count),
    ctypes.byref(cpu_info),
    ctypes.byref(cpu_info_count)
)

if ret != 0:
    print(" ".join(["0.00"] * 14))
    sys.exit(0)

n = cpu_count.value
ticks = []
for i in range(n):
    base = i * CPU_STATE_MAX
    user = cpu_info[base + CPU_STATE_USER]
    system = cpu_info[base + CPU_STATE_SYSTEM]
    idle = cpu_info[base + CPU_STATE_IDLE]
    nice = cpu_info[base + CPU_STATE_NICE]
    ticks.append((user + system + nice, idle))

prev = None
if os.path.exists(sys.argv[1]):
    with open(sys.argv[1]) as f:
        prev = json.load(f)

with open(sys.argv[1], 'w') as f:
    json.dump(ticks, f)

if prev and len(prev) == n:
    results = []
    for i in range(n):
        d_active = ticks[i][0] - prev[i][0]
        d_idle = ticks[i][1] - prev[i][1]
        total = d_active + d_idle
        pct = d_active / total if total > 0 else 0
        results.append(f"{pct:.2f}")
    print(" ".join(results))
else:
    print(" ".join(["0.00"] * n))
PYTHON
)

read -ra V <<< "$values"
for i in $(seq 0 13); do
    sketchybar --push cpu_core.$i "${V[$i]:-0}"
done
