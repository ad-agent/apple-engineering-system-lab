# Trial 005 follow-up: separate autonomous refinement run (Decision 006 step 4)

This is a separate experiment on a new copy of the frozen arm-v02 submission. It is not part of Trial 005's scored
comparison and changes nothing in RESULTS.md. Both frozen arms are untouched: after the run, arm-v02 was still at
`4207fed` and arm-control at `36c91ba`, with no changes in either. It is one run of one arm with different guidance and
a different instruction, so it says nothing about AES against the control arm. All observations below come from the
run's own transcript and notes. **No assessor has checked the refined app yet.**

## Setup

- **Copy.** A new folder `refine-v02` in the Trial 005 run folder: a clone of arm-v02 at participant commit `7caa43b`
  (branch `refine`, remote removed). The arm's own frozen inputs (the AES skill as the arm had it, `CLAUDE.md`,
  `OBJECTIVE.md`, the 44 s participant reference) were copied from the arm folder. All 14 matched
  `arm-v02.manifest.sha256`.
- **Instruction.** `REFINE.md` (text below). It repeats Decision 006 step 4's wording: inspect, critique and refine;
  exercise the primary user journeys; stop when the essential experience is verified, the budget is exhausted or a
  blocker prevents continuing. It gives a 30-minute budget from the start time and adds one exception to the folder
  rule (COMPLETION.md, implication 5). It names no journey, defect or assessor check.
- **Guidance.** Xcode's own plugin was loaded with `--plugin-dir`, which made its 15 skills available, including
  `xcode-integration:device-interaction`. Under `--strict-mcp-config`, the plugin's own `xcode` server is dropped, so
  the arm's `xcode-tools` server was the only MCP server (checked with a load check before the run).
  `DEVICE-METHOD.md` holds the method and command forms from [DEVICE-INTERACTION.md](../DEVICE-INTERACTION.md),
  without the fixture measurements and without the "Known limits" pointers to RESULTS.md.
- **Subagent.** The Agent tool was not in `--allowedTools`, the same tool set as the arm. `DEVICE-METHOD.md` told the
  agent to call the device tools itself, as step 2 verified. Xcode's skill asks for a subagent; the lead decided
  against it for comparability with the arm and Decision 006 §6.
- **Launch.** Same as the arm-v02 command in ARMS.md, with `timeout 1800` instead of 3600, the plugin added, and the
  prompt `/apple-product-engineering Read REFINE.md, DEVICE-METHOD.md and CLAUDE.md in this folder and do what
  REFINE.md says.` Model: Opus 5.5, `acceptEdits`. It ran detached from any session on `iPhone 18 Pro Max`. At the
  start, the shared lock was free and memory pressure was at "warn".

## Outcome

| | |
|---|---|
| Ran | 2026-11-26 22:21:44 to 22:29:21 local (7 min 37 s of the 30 min). It ended by itself; neither the timeout nor a usage limit stopped it |
| Result | `success`, 83 turns. `claude -p` reported $2.84 as an API-equivalent cost. The 5-hour window went from 22 % at 22:18 to 38 % at 22:30, including the lead's own use |
| Tool calls | 81: 24 `DeviceInteractionSynthesize`, 1 start and 1 end session, 25 Bash, 18 Read, 9 Edit, 1 Write, 1 Skill (`xcode-integration:device-interaction`), 1 ToolSearch |
| Device actions | 8 multi-point drags (`mt`), 8 taps (`t`), text input through `sender keyboard kbd`, 6 waits, 1 empty capture |
| Code change | One commit, `f0a0ca0`, by the agent: `ContentView.swift`, `Place.swift`, `PlaceSheet.swift` (+67 −34 in source) and its `REFINEMENT-NOTES.md` |
| Its stated reason for stopping | It had run the main journeys before and after its changes, and the time was "inside the 30-minute budget". About 22 minutes were left. It listed what it had not verified (below) |

## What it exercised (agent-reported)

It ran each journey on the unchanged app first and again after its changes:

- Launch.
- Dragging the sheet between its heights, in both directions.
- Panning the map with the sheet at the middle height.
- Search: focusing the field, typing, Return, then dragging the sheet down.
- Choosing a result, closing the details.
- Selecting a marker with the sheet collapsed, then collapsing it again with the details open.
- Cancelling the search.

It compared hierarchy frames between captures (marker positions, the position of the map's Legal link) and read the
app's log through `simctl`. Typing worked through the hardware keyboard. It saw no on-screen keyboard and said so.

## Defects it found and changed (agent-reported, not yet checked by an assessor)

1. **The map ignored text search.** The list filtered, but the map kept all 40 markers. Cause it gave: the query lived
   only in the sheet. Change: one shared filter feeds the list and the markers, and Return frames the results above
   the sheet and moves the sheet to the middle height.
2. **The map moved whenever the sheet settled at another height.** Cause it gave: the map's bottom safe-area padding
   followed the sheet's height. Change: the padding is constant, and the app's own camera moves aim at the part of
   the map the sheet leaves visible. Its first attempt left the map's logo and Legal link floating mid-screen; it
   saw that in the run and replaced it.

## What it left unverified or open (its own list)

- Search-result framing is loose. Clearing the query restores the markers but does not reframe the map.
- Keyboard overlap: unchecked, because no on-screen keyboard appeared.
- Not checked: dark mode, Dynamic Type, landscape, VoiceOver, feel and frame pacing.
- Section headers render grey although the code asks for `.primary`. It noted this and did not investigate.
- The project has no tests.

## Against the assessor's existing findings for arm-v02 (RESULTS.md, finding labels)

The assessor's findings were hidden from the agent until this run ended. They are compared here only to see what it
found on its own:

- **Cancel returns the sheet to the middle height, not to the height where search began** (App; measured three
  times). The agent ran Cancel and checked that the markers came back. It did not report the sheet height after
  Cancel, and the code still sets it.
- **AX5: row icon glyphs overflow their discs** (App), and **the floating map controls do not scale** (App, minor;
  both arms). Not found: the agent did not check Dynamic Type.
- **The search field exposes only its placeholder; some decorative symbols are exposed under default names** (App,
  minor; both arms). Not found: the agent did not check accessibility.
- Neither of its two defects is in the assessor's finding table. Whether C1–C12 would have caught them is not
  established here.

## Rule notes (from the transcript and its notes)

- **Lock.** It held the shared lock for builds, `simctl` and device calls. It released the lock, then ran one last
  build under `lockf`, which is allowed after a release.
- **Simulator.** It used only `iPhone 18 Pro Max`, and builds used `-derivedDataPath ./DerivedData`.
- **Deviation from the folder rule.** Two build logs went to its Claude Code scratchpad under `/private/tmp`, outside
  the project folder.
- **Cleanup.** No `.hold` was left behind.

## Limits of this record

The defects and fixes above are as the agent reported them. The transcript shows the device calls were made. The
lead did not rerun them, and no assessor has run C1–C12 against `f0a0ca0`. That would be a separate lock window, and
Decision 006 does not name it. The evidence stays private: the transcript, the agent's screenshots and hierarchies,
and the run folder.

## `REFINE.md` as given (start time filled in at launch)

> This folder is a copy of the Waypoints app you built earlier for `OBJECTIVE.md`; `NOTES.md` holds your notes from
> then. That assignment's 60-minute budget no longer applies.
>
> Independently inspect, critique and refine the running app. Exercise its actual primary user journeys on the
> simulator, identify meaningful defects, investigate their causes and make focused improvements. Stop when the
> essential experience is verified, the budget is exhausted, or a genuine blocker prevents you from continuing.
>
> - Budget: 30 minutes, from 22:21 local. The session is stopped at that point; check the time with `date`.
> - Device tools: `DEVICE-METHOD.md` says how to use Xcode's device-interaction tools and its own guidance, which is
>   loaded as the `xcode-integration` plugin skills.
> - `CLAUDE.md` applies, with one addition to its folder rule: you may also read the files the Xcode tools write and
>   name in their replies (screenshots, hierarchies, logs), and Xcode's bundled guidance.
> - Before you stop, write a short `REFINEMENT-NOTES.md` in the project root: what you exercised, what you found,
>   what you changed and why, and what you could not verify.
