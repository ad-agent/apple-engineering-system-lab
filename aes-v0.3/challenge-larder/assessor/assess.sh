#!/bin/sh
# assess.sh <label> — starts one assessor run detached (30 min), the same script and flags for every label.
# Run inside the heavy turn and quiet lane (see STATE "How runs are launched"). Never shown the arm.
set -e
RUN=~/Scratch/AppleEngineeringSystem/2026-11-27-larder-run; A="$RUN/assess"; L="$1"; cd "$A"
[ -d "$A/$L" ] || { echo "no $A/$L"; exit 1; }
[ -e "$A/$L.start" ] && { echo "already started: $(cat $A/$L.start)"; exit 1; }
U=7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740
xcrun simctl boot $U 2>/dev/null || true
xcrun simctl terminate $U test.aes.Larder 2>/dev/null || true
xcrun simctl uninstall $U test.aes.Larder 2>/dev/null || true
xcrun simctl ui $U appearance light; xcrun simctl ui $U content_size large
mkdir -p "$A/$L/evidence"
P="$(xcrun mcpbridge run-agent plugin path --plugin-format claude)"
PROMPT="LABEL is $L. Read ASSESSOR.md in this folder and do exactly what it says for $L. Start time: $(date '+%H:%M %Z'); you have 30 minutes."
{ date '+%F %T %z'; uptime; memory_pressure -Q 2>/dev/null | tail -1; } > "$A/$L.load"
date '+%F %T %z' > "$A/$L.start"
nohup perl -e 'use POSIX qw(setsid); setsid(); exec @ARGV' timeout 1800 claude -p "$PROMPT" \
  --setting-sources project --strict-mcp-config --mcp-config "$RUN/mcp.json" --plugin-dir "$P" \
  --model claude-opus-5-5 --permission-mode acceptEdits --output-format stream-json --verbose \
  --allowedTools "Bash,Read,Edit,Write,Glob,Grep,Skill,mcp__xcode-tools" --disallowedTools "Agent" \
  </dev/null > "$A/$L.jsonl" 2> "$A/$L.err" &
PID=$!; echo $PID > "$A/$L.pid"
( while kill -0 $PID 2>/dev/null; do sleep 20; done; date '+%F %T %z' > "$A/$L.end"; { date '+%F %T %z'; uptime; } >> "$A/$L.load" ) </dev/null >/dev/null 2>&1 &
~/Developer/codedirector-briefs/tools/keep-awake.sh --pid $PID "AES Larder assess $L" | tail -1
echo "started assessor $L pid $PID; log $A/$L.jsonl"
