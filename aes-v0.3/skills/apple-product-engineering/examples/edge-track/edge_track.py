#!/usr/bin/env python3
"""Measure where a moving surface's vertical edge is in every frame of a screen recording.

Why: "the motion looks smooth" is a judgement; a per-frame edge position shows jumps at touch-down, velocity
breaks at release, overshoot and stalls, and can be compared with what the code meant to do.

Usage:
  python3 -I edge_track.py RECORDING --start 30.5 --end 33.0 --band 0.30 0.40 [--fps 60] [--width 440]
    --band   vertical slice of the screen to scan, as fractions of its height (pick rows the edge crosses and
             little else moves in)
    --width  frames are scaled to this many pixels wide; positions are reported in those pixels and as a fraction
Output: CSV lines  t_seconds,edge_x_px,edge_x_fraction,step_px  (step = change since the previous frame)
Needs ffmpeg on PATH. Plain Python, no packages.
"""
import argparse, subprocess, sys

ap = argparse.ArgumentParser()
ap.add_argument("video")
ap.add_argument("--start", type=float, required=True)
ap.add_argument("--end", type=float, required=True)
ap.add_argument("--band", type=float, nargs=2, default=(0.3, 0.4))
ap.add_argument("--fps", type=float, default=60)
ap.add_argument("--width", type=int, default=440)
ap.add_argument("--min-x", type=float, default=0.02, help="ignore edges left of this fraction (screen bezel)")
a = ap.parse_args()

probe = subprocess.run(["ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries", "stream=width,height",
                        "-of", "csv=p=0", a.video], capture_output=True, text=True, check=True).stdout.split(",")
src_w, src_h = int(probe[0]), int(probe[1])
w = a.width
h = round(src_h * w / src_w / 2) * 2
y0, y1 = int(a.band[0] * h), int(a.band[1] * h)

raw = subprocess.run(["ffmpeg", "-v", "error", "-ss", str(a.start), "-to", str(a.end), "-i", a.video,
                      "-vf", f"fps={a.fps},scale={w}:{h},format=gray", "-f", "rawvideo", "-"],
                     capture_output=True, check=True).stdout
frame = w * h
prev = None
print("t_seconds,edge_x_px,edge_x_fraction,step_px")
for i in range(len(raw) // frame):
    f = raw[i * frame:(i + 1) * frame]
    # Column profile: mean brightness of each column inside the band.
    cols = [sum(f[y * w + x] for y in range(y0, y1)) / (y1 - y0) for x in range(w)]
    lo = max(1, int(a.min_x * w))
    # Strongest brightness step between neighbouring columns (smoothed over 2 px) is the edge.
    best_x, best = None, 0.0
    for x in range(lo, w - 2):
        d = abs((cols[x + 1] + cols[x + 2]) - (cols[x - 1] + cols[x])) / 2
        if d > best:
            best, best_x = d, x
    t = a.start + i / a.fps
    step = "" if prev is None or best_x is None else best_x - prev
    print(f"{t:.3f},{best_x},{(best_x or 0) / w:.3f},{step}")
    prev = best_x
