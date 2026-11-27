# AES v0.3 verification (Decision 007 §6)

Run on 2026-11-27 by the AES lead with Xcode 27.2 (27B52), Claude Code 2.1.311, Opus 5.5 for every agent run, and the
`iPhone 18 Pro Max` simulator (iOS 27). Raw transcripts and screenshots are private in
`~/Scratch/AppleEngineeringSystem/2026-11-27-d007-probes/` (they show real map tiles and the owner's global rules;
never publish). This page records what was run and what it showed. It does not claim that v0.3 makes better apps.

## 1. Apple integration and knowledge retrieval

| Check | Result |
|---|---|
| Plugin found the way the skill says (`xcrun mcpbridge run-agent plugin path --plugin-format claude`), no stored path | Found `…/ExportedPlugins/27B52/claude` with 16 skills ([evidence/check_apple_refs.out](evidence/check_apple_refs.out)) |
| Every Apple skill named in SKILL.md's table exists in that plugin | 13 of 16 routed, all present. Not routed on purpose: `adopt-c-bounds-safety`, `audit-xcode-security-settings`, `translation` (reached through `translation-coordinator`) |
| Referenced Apple files exist | `swiftui-specialist/references/animations.md` and `soft-deprecated-apis.md`; 20 Markdown files in `AdditionalDocumentation` |
| Compatibility correction found when it matters (probe P1, below) | v0.2 and v0.3 as first written: the agent loaded only Apple's `device-interaction` and named the tool `DeviceEventSynthesize` (wrong on 27.2). After adding "before driving the app with Xcode's device tools" to v0.3's description: the agent loaded AES, then `runtime.md`, then Apple's skill, and named `DeviceInteractionSynthesize`, citing the correction |
| Runtime commands in runtime.md work | `simctl ui … content_size accessibility-extra-extra-extra-large` and `appearance dark` set and restored (`large`, `light` read back), in the heavy lane |
| Agent with the skill uses Apple's tools in a real task (E1–E1c) | Each run invoked AES, read runtime.md's settings lines, and drove the app with `DeviceInteractionSynthesize` directly (no subagent), with hierarchy reads after each action |

Script: [evidence/check_apple_refs.sh](evidence/check_apple_refs.sh). Run it again after an Xcode update.

## 2. Behavioural probes against the Decision 006 deficiencies (matched v0.2 / v0.3)

Five short headless prompts, each run once per version, in identical folders that differed only in the skill. Same
model, same plugin, no device tools, no edits. One run each, so these show behaviour, not rates.

| Probe | Decision 006 deficiency | v0.2 | v0.3 |
|---|---|---|---|
| P1 retrieval | Tool knowledge, compatibility corrections | Apple skill only; wrong tool name | Same at first; fixed by the description change above |
| P2 completion: 22 of 30 min left, Cancel end state unchecked, no AX5 | Stopping with an essential condition unverified | Continues: re-runs Cancel against the smallest height, then AX5, dark, VoiceOver | Continues with the same checks, plus a second starting state (middle → middle) and hierarchy frames as the measure |
| P3 journeys before implementation | No written end states | Acceptance list; Cancel "returns to the height it had before", tested from each start | Journey table start → action → end → principle; Cancel from small, medium and large, plus drag-during-search |
| P4 tool error on typing | Blocker declared without an alternative | Fix syntax, retry once, then report a blocker | Fix syntax, retry once, then **another route first** (`simctl pbcopy` and paste) before a blocker |
| P5 open design questions | Asking about routine choices | Decides both and continues (citing the owner's mission rules) | Decides both and continues ("routine choices, not money, keys, deleting data") |

The probes state the gap in the prompt, so v0.2 also did well on P2 and P5. In Trial 005 the failures came out of long
runs where nobody pointed out the gap. Section 3 is the closer test of that.

**Confound in every run.** Headless `claude -p` also loaded the owner's `~/.claude/CLAUDE.md`: answers cited R1, R8,
R10 and mission rules, and in P3 both versions asked the owner where to create the project. `--setting-sources
project` did not prevent it, and `--bare` needs an API key. It applied equally to both versions.

## 3. Runtime criticism on a real app (E1, v0.3 only)

The installed refined Waypoints build from Decision 006 (`refine-v02` `f0a0ca0`, bundle `test.aes.Waypoints`), with
its brief and the reference recording, and the task "evaluate the running app as a demanding user and an Apple
reviewer would" in 12 minutes. No source code, no edits. The agent was not told about any known defect. The
comparison is with what earlier runs on the same app saw, which is not a matched comparison: the refinement run had a
different task, and the assessor knew what to look for.

| Known defect (assessor, REFINEMENT.md) | refine-v02 run (v0.2, own app) | E1 (v0.3) |
|---|---|---|
| Cancel from the smallest height returns to the middle height (C5) | Missed: checked that the markers came back | **Found** (D1): start "small", observed "Half screen" in the hierarchy |
| Default symbol names as labels (C9) | Not checked | **Found** (D5): Image labelled "Water Waves" |
| AX5 row icons overflow (C8) | Not checked | Not found: AX5 and dark were run on the detail card only, not the list rows |
| Placeholder-only search field (C9) | Not checked | Not found |

E1 also reported new candidate defects that the assessor has not confirmed (an empty 133 pt row in the detail card,
overlapping markers without clustering, metres beside miles, duplicate map labels in the hierarchy).

**Completion.** E1 stopped after 5 min 26 s of 12 (63 turns), with a primary journey, dragging the sheet between its
three heights, under "not checked". That is the Decision 006 completion weakness again. v0.3 was then changed: in an
evaluation the primary journeys are essential, and before stopping the agent compares its "not checked" list with the
essential conditions. E1b reran the same task with that change: see section 4.

## 4. E1b and E1c (same task, each after one targeted change)

| | E1 | E1b | E1c |
|---|---|---|---|
| Skill change before the run | — | "not checked" list compared with the essential conditions | plus: read the clock at start and before stopping |
| Time used of 12 min | 5 min 26 s | 5 min 08 s | 6 min 20 s (clock read 6 times) |
| Device actions | 19 | 19 (2 multi-point drags) | 22 |
| Cancel from small returns to medium (known, C5) | Found | Found | Found, and the same fault when closing a place opened from small (new) |
| AX5 rows overlap or clip (known, C8) | Not found (detail only) | Found (sheet content clips and overlaps) | Found (list rows overlap) |
| Map controls don't scale with text size (known) | Not found | Not found | Found |
| Placeholder-only search field (known, C9) | Not found | Not found | Not found |
| Symbol name as a label (known, C9) | Found | — | — |
| Primary journey left "not checked" | Sheet drag between heights | Some starting states of "choose a place"; reversal | None; remaining items are polish or device-only (drag feel, real VoiceOver, chips, landscape), plus the console |
| Stated reason for stopping | — | "time budget of 12 min", with 7 min left | Clock read; essential journeys covered |

**What this shows.** On this app, the v0.3 agent found the Cancel end-state defect that v0.2's runs did not see,
every time. With the large-text pass it also found the large-text defects in two of three runs. The early stop
changed shape. E1 left a primary journey unchecked. E1b stopped and gave "time budget" as the reason, with 7 of 12
minutes left. E1c read the clock, covered the essential journeys, and stopped with only polish and device-only items
open. That is the stop SKILL.md §3 asks for, though it skipped the console read that runtime.md lists. These are three
runs, each after a change, of one model on one app. They show the rules can work; they do not measure how often.

**Cost.** E1, E1b and E1c: $1.66, $1.75 and $1.77 API-equivalent (`claude -p`). The 5-hour window went from 8 % to
about 45 % across all of this session's checks and the lead's own work.
