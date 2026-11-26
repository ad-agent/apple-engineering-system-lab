#!/usr/bin/env python3
"""Summarize skill activation from a Claude Code stream-json transcript (claude -p --output-format stream-json --verbose).
Prints: whether the skill body was injected, every Read/Grep/Glob of a skill file in order, files edited, turns, result.
Usage: python3 -I activation_trace.py run.jsonl
"""
import json, sys

injected, reads, edits, n_tool = False, [], [], 0
result = None
for line in open(sys.argv[1]):
    try:
        m = json.loads(line)
    except ValueError:
        continue
    if m.get("type") == "user" and "Read before you decide" in json.dumps(m.get("message", {})):
        injected = True
    if m.get("type") == "assistant":
        for c in m["message"].get("content", []):
            if c.get("type") != "tool_use":
                continue
            n_tool += 1
            name, inp = c["name"], c.get("input", {})
            target = inp.get("file_path") or inp.get("path") or inp.get("pattern") or inp.get("skill") or ""
            if "apple-product-engineering" in json.dumps(inp) or name == "Skill":
                reads.append(f"{name}: {target.split('apple-product-engineering/')[-1]}")
            if name in ("Edit", "Write"):
                edits.append(target.rsplit("/", 1)[-1])
    if m.get("type") == "result":
        result = {k: m.get(k) for k in ("subtype", "num_turns", "duration_ms", "is_error")}
print("skill body in this stream:", injected, "(claude -p stream-json omits the expanded slash command; check the session transcript)")
print("skill files touched, in order:", reads or "none")
print("files edited:", sorted(set(edits)))
print("tool calls:", n_tool, "| result:", result)
