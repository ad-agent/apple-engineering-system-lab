# Trial 005: frozen inputs and arm configuration (frozen 2026-11-26 15:56)

Supersedes the Trailhead task B in PLAN.md: Decision 005 puts the Maps-style challenge in a fresh, isolated project.
The Trailhead filter-sheet task stays a separate transfer evaluation (builder still to be decided).

## Frozen inputs

| Input | Where (outside git unless noted) | SHA-256 |
|---|---|---|
| Operator's original recording (52.2 s, physical iPhone, audio). Private: shows the operator's location; never publish | `~/Data/AppleEngineeringSystem/trial-005/reference/maps-reference.mp4` | `7b8ad86b9c3569a8dd8e3a9d228e1f558249af59de64cb4ec30c7c6b30cedad7` |
| Participant copy: 0–44.0 s, no audio, ending before any address card (owner's choice, 2026-11-26) | `…/reference/maps-reference-participant.mp4`; in each arm as `reference/maps-reference.mp4` | `0c316445f0d4d35a7a5ea3792ef6485e91d892490edfbbcfcf0cc1cea5cbb5ef` |
| Starter: Xcode 27.2 iOS App template `Waypoints` (made by `XcodeNewProject`), `places.json` (40 fictional places, seed 5005), workspace-relative DerivedData setting; builds | `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/starter`, local git commit `90951d3` | per-file in `arm-*.manifest.sha256` |
| Objective and project rules | this repo: `participant/OBJECTIVE.md`, `participant/CLAUDE.md` | in the manifests |
| Assessor checks | this repo: `assessor/CHECKS.md` (never copied into an arm) | — |

Arms: `…/2026-11-26-trial005-run/arm-control` and `…/arm-v02`, cloned from the starter. Apart from git metadata, they
differ only in `.claude/skills/apple-product-engineering` (v0.2 at e1cb691, 11 files) in `arm-v02`; checked with
the manifests. `mcp-arm-*.json` (only `xcode-tools` → `xcrun mcpbridge`) are byte-identical. Arm order by coin flip
(`coin-flip.log`): **control first**.

## Run (one arm at a time; the next lead runs them)

Before each arm:
- `get_usage` shows enough room in the 5-hour window for 60 minutes of Opus. Start an arm only if a usage limit cannot
  cut it short; otherwise wait for the reset. A cut arm is void and is rerun, never scored.
- Xcode approval for the arm folder. Either the owner runs once
  `sudo xcrun mcp-server allow-folder ~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run`, or the owner
  approves the prompt the arm's first `XcodeOpenWorkspace` raises; that approval is logged as an intervention in
  both arms. `com.anthropic.claude-code` is already a permitted agent.
- No lock window is held by the lead; the participant takes its own windows under its `CLAUDE.md`. The lead checks
  `light-turn.sh --status` and starts only when the heavy lane is free.

Command (from the arm folder; the only difference between arms is the leading `/apple-product-engineering`):

```
P='Read OBJECTIVE.md and CLAUDE.md in this folder and complete the objective.'
# control:  PROMPT="$P"        experimental:  PROMPT="/apple-product-engineering $P"
nohup perl -e 'use POSIX qw(setsid); setsid(); exec @ARGV' timeout 3600 claude -p "$PROMPT" \
  --setting-sources project --strict-mcp-config --mcp-config ../mcp-<arm>.json --model claude-opus-5-5 \
  --permission-mode acceptEdits \
  --allowedTools "Bash,Read,Edit,Write,Glob,Grep,Skill,mcp__xcode-tools" \
  --output-format stream-json --verbose </dev/null > ../<arm>.jsonl 2> ../<arm>.err &
```
then `keep-awake.sh --pid <PID> "AES lead: trial005 <arm>"`, and put the PID and log in STATE.

After each arm: `git -C <arm> add -A && git commit` (the arm's result, kept for diffing against `90951d3`); copy
nothing out of the folder; close the arm's Xcode workspace. Scoring uses `assessor/CHECKS.md` in a lead-held lock
window, after both arms have finished.
