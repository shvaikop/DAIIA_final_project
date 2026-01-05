#!/usr/bin/env python3
"""
Parse GAMA happiness statistics from a log file and generate matplotlib graphs.

Expected log line format (others are ignored):
cycle: 20|| HAPPINESS STATS: ALL GUESTS: | min=0.47 max=0.58 mean=0.52 median=0.50
"""

import argparse
import os
import re
from collections import defaultdict
from typing import Dict, List, Tuple

import matplotlib.pyplot as plt


LINE_RE = re.compile(
    r"^cycle:\s*(?P<cycle>\d+)\s*\|\|\s*HAPPINESS STATS:\s*(?P<label>.*?)\s*\|\s*"
    r"min=(?P<min>[0-9Ee+\-\.]+)\s*"
    r"max=(?P<max>[0-9Ee+\-\.]+)\s*"
    r"mean=(?P<mean>[0-9Ee+\-\.]+)\s*"
    r"median=(?P<median>[0-9Ee+\-\.]+)\s*$"
)


def sanitize_label(label: str) -> str:
    # Remove trailing ":" if present and normalize spacing
    label = label.strip()
    while label.endswith(":"):
        label = label[:-1].strip()
    label = re.sub(r"\s+", " ", label)
    return label


def parse_log(path: str) -> Dict[str, List[Tuple[int, float, float, float, float]]]:
    """
    Returns dict[label] -> list of (cycle, min, max, mean, median)
    """
    data: Dict[str, List[Tuple[int, float, float, float, float]]] = defaultdict(list)

    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            m = LINE_RE.match(line)
            if not m:
                continue

            cycle = int(m.group("cycle"))
            label = sanitize_label(m.group("label"))

            min_v = float(m.group("min"))
            max_v = float(m.group("max"))
            mean_v = float(m.group("mean"))
            median_v = float(m.group("median"))

            data[label].append((cycle, min_v, max_v, mean_v, median_v))

    # Sort each label's entries by cycle
    for label in list(data.keys()):
        data[label].sort(key=lambda t: t[0])

    return data


def plot_label(
    label: str,
    rows: List[Tuple[int, float, float, float, float]],
    out_dir: str,
    ylim: Tuple[float, float] = (0.0, 1.0),
) -> str:
    cycles = [r[0] for r in rows]
    mins = [r[1] for r in rows]
    maxs = [r[2] for r in rows]
    means = [r[3] for r in rows]
    medians = [r[4] for r in rows]

    plt.figure()
    plt.plot(cycles, mins, label="min")
    plt.plot(cycles, maxs, label="max")
    plt.plot(cycles, means, label="mean")
    plt.plot(cycles, medians, label="median")
    plt.xlabel("cycle")
    plt.ylabel("happiness")
    plt.ylim(*ylim)
    plt.title(f"Happiness stats — {label}")
    plt.legend()
    plt.grid(True, alpha=0.3)

    safe = re.sub(r"[^A-Za-z0-9_\-]+", "_", label).strip("_")
    out_path = os.path.join(out_dir, f"happiness_reinforce_{safe}.png")
    plt.tight_layout()
    plt.savefig(out_path, dpi=200)
    plt.close()
    return out_path


def plot_means_comparison(
    data: Dict[str, List[Tuple[int, float, float, float, float]]],
    out_dir: str,
    ylim: Tuple[float, float] = (0.0, 1.0),
) -> str:
    """
    Single chart with mean happiness for each label over cycles.
    """
    plt.figure()
    for label, rows in sorted(data.items()):
        cycles = [r[0] for r in rows]
        means = [r[3] for r in rows]
        plt.plot(cycles, means, label=label)

    plt.xlabel("cycle")
    plt.ylabel("mean happiness")
    plt.ylim(*ylim)
    plt.title("Mean happiness comparison (all groups)")
    plt.legend(fontsize=8)
    plt.grid(True, alpha=0.3)
    out_path = os.path.join(out_dir, "happiness_means_comparison_reinforce1.png")
    plt.tight_layout()
    plt.savefig(out_path, dpi=200)
    plt.close()
    return out_path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("logfile", help="Path to the .log file (e.g., basic_0.log)")
    ap.add_argument(
        "-o", "--out",
        default="happiness_plots_new",
        help="Output directory for PNG files (default: happiness_plots)"
    )
    ap.add_argument(
        "--ylim",
        default="0,1",
        help="Y-axis limits as 'min,max' (default: 0,1)"
    )
    args = ap.parse_args()

    y0_s, y1_s = args.ylim.split(",")
    ylim = (float(y0_s), float(y1_s))

    os.makedirs(args.out, exist_ok=True)

    data = parse_log(args.logfile)
    if not data:
        raise SystemExit("No happiness stat lines found. Check the log format / file path.")

    print(f"Found groups: {', '.join(sorted(data.keys()))}")

    # Plot per group
    for label, rows in sorted(data.items()):
        out_path = plot_label(label, rows, args.out, ylim=ylim)
        print(f"Wrote: {out_path}")

    # Plot comparison of means across groups
    comp = plot_means_comparison(data, args.out, ylim=ylim)
    print(f"Wrote: {comp}")


if __name__ == "__main__":
    main()
