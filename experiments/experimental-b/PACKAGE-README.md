# AES Experiment B — review package (Folio workspace reveal)

The trial state is frozen. This package was assembled after the trial without any change to the participant repository: no source, test or project edits, no new commits, and no new app runs. The only post-trial outputs are JSON exports from the existing xcresult bundles and frame strips cut from an existing recording. Both are labelled.

This package makes no claim about whether AES improved engineering quality.

## Frozen state

| Item | Value |
|---|---|
| Repository | `/Users/x/Documents/Codex/2026-11-25/apple-product-engineering-mission-deliver-applications-2/work/trials002/B` |
| Baseline | `7764604840e0be2a1c0ddf1ca4f50c2efe3d89fc` |
| Final commit | `5e5167fbc2b01ac5a34c613b2c4141f17914c2ce`, branch `workspace-reveal`, not pushed, tree `15edd1a2…` |
| Working tree | equals HEAD for tracked files; untracked `.agents/`, `.claude/` hold the skill copies and local settings |

## Contents (individual files, no archives)

- `implementation/`
  - `source/`: final production sources (`Sources/`), unit tests (`Tests/`), UI tests (`UITests/`) and project configuration (`Folio.xcodeproj/project.pbxproj`, workspace data, shared scheme). All are exported from the final commit.
  - `baseline-7764604..5e5167f.diff`: the complete diff, including the two new files (`Sources/WorkspaceReveal.swift`, `Tests/WorkspaceRevealTests.swift`), plus `baseline-diffstat.txt`.
  - `SOURCE-MANIFEST.sha256`, `git-ls-tree-HEAD.txt`, `FROZEN-STATE.txt`
- `runtime/`
  - `RECORDINGS.md`: scenario index with video times, and the scenarios **not** recorded.
  - `recordings/`: `light-recording.mov` and `darkxl.mov`, trial-time and final source.
  - `screenshots/`: `trial-final-source/`, `trial-baseline/`, `trial-composites/`, and `post-trial-derived/` (kept separate).
- `verification/`
  - `VERIFICATION.md`: per-run results, warnings, performance and limitations.
  - JSON summaries and per-test JSON for each run.
  - The final Xcode build log (`final-build.log`) and execution log (`final.log`), plus the same for baseline, darkxl and light-recording.
- `aes/`
  - `AES-EVIDENCE.md`: session ID, model and effort, skill activation, references read, decisions, durations, interventions, difficulties, and corrections to the trial report.
  - `session-transcript-redacted.md`
  - `skill-and-task-hashes.txt`
  - `data-before.sha`, `data-after.sha`
- `PACKAGE-MANIFEST.sha256`: SHA-256 of every file in this package.

## Key facts for the reviewer

- **Final run:** 16/16 tests passed: 4 public unit, 6 new unit, 5 public UI, 1 new UI. There were 0 skipped and 0 excluded. The baseline was 9/9.
- **Specialist skill references read during the trial: none.** Only the SKILL.md body, injected by the slash command, was in context.
- **Not recorded or not exercised at runtime:**
  - a committed close by drag
  - reversal within one gesture
  - interruption
  - flick
  - haptics
  - back swipe
  - Reduce Motion
  - VoiceOver escape
  - iPad
  - iOS 17
- **Runtime warnings:** `Invalid frame dimension` in every run, baseline included. The final run also had 4 animation-quiescence stalls of about 60 s; their cause was not determined.
- **No performance profiling.**
- **The trial-time report and commit message contain overstatements.** They are corrected in `aes/AES-EVIDENCE.md`.

## Not included (retained locally)

The originals are in `~/Scratch/Folio/2026-11-26-workspace-reveal/`, which now carries a `KEEP.md`:
- raw `.xcresult` bundles, DerivedData (`dd-before`, `dd-after`), `final.mov` (208 MB)
- recordings and logs of superseded intermediate runs
- the reference-video contact sheets
- the source export of the original used for diagnosis

The full session transcript JSONL stays in `~/.claude/projects/`.
