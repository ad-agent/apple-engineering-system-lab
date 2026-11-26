# Trial 005 follow-up: separate autonomous refinement run (Decision 006 step 4)

This is a separate experiment on a new copy of the frozen arm-v02 submission. It is not part of Trial 005's scored
comparison and changes nothing in RESULTS.md. Both frozen arms are untouched: after the run, arm-v02 was still at
`4207fed` and arm-control at `36c91ba`, with no changes in either. It is one run of one arm with different guidance and
a different instruction, so it says nothing about AES against the control arm. All observations below come from the
run's own transcript and notes, except the section "Assessor checks on `f0a0ca0`", which an assessor ran afterwards.

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

## Defects it found and changed (agent-reported; the assessor's check is further down)

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
  times on arm-v02, and four more times on the refined app below). The agent ran Cancel and checked that the markers came back. It did not report the sheet height after
  Cancel, and the code still sets it.
- **AX5: row icon glyphs overflow their discs** (App), and **the floating map controls do not scale** (App, minor;
  both arms). Not found: the agent did not check Dynamic Type.
- **The search field exposes only its placeholder; some decorative symbols are exposed under default names** (App,
  minor; both arms). Not found: the agent did not check accessibility.
- Neither of its two defects is in the assessor's finding table. C1–C12 test neither one directly. The assessor
  check below confirms the second fix by measurement and does not exercise the first.

## Assessor checks on `f0a0ca0` (C1–C12, run after the refinement)

**How they were run.** 2026-11-26 22:50:00–22:58:09, in one lead-held lock window: `lockf` + `turn-holder.sh` +
`quiet.sh` around one script, with nothing else in the heavy lane. A short second window, 22:59:03–23:00:06, redid two
checks that the first window's automation got wrong (see the deviations below). Simulator: `iPhone 18 Pro Max` only.
The source was exported with `git archive f0a0ca0` and built in Debug with `-derivedDataPath` in the assessment
folder. The build succeeded with no compiler warnings. Then uninstall and install, and the sequence of Decision 006
step 1:
- a cold-launch series of six launches without MCP;
- C1–C12 in a fresh MCP device session, using the command sequence of the 18:10 window from RESULTS.md, with targets
  found in the previous hierarchy instead of at fixed points;
- the 24 matched states of step 1, recorded with `simctl io recordVideo` (78 s).

Dynamic Type and appearance were `large` and `light` at the start and end of both windows (checked). The refined
build is left installed. The assessor knew which app this was, so the checks were not blind. The evidence stays
unpublished in `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/assess/refine-v02/`: its screenshots show
map tiles of a real area. Labels as in RESULTS.md: **measured**, **observed**, **code**, **asserted**.

**Deviations (Auto: the assessor's automation)**
- In the first window, two typing steps sent `kbd falcon w 0.8`, which typed the wait suffix into the field as text.
  The journey's state 11 typed "falcon" correctly, and "lake" was typed again in the second window.
- The first window's Time Profiler attach failed ("Cannot find process for provided pid") because the command lacked
  `--device`. C12 was recorded in the second window with `--device <udid> --attach <pid>`. There, the app had already
  been launched and driven through MCP before the trace started. The arms' traces began at the first MCP activation,
  so the conditions differ.
- The first window's AX5 detail tap landed on the search field instead of a row. The journey's state 23 opened a row's
  details at AX5.
- The cold-launch series ran while the Mac was heavily loaded: load average 11.3 just before the window and 13.6
  during it. Screenshot polling slowed to one frame every 0.7–3.5 s, against about 0.48 s in step 1.

| # | refine-v02 `f0a0ca0` | Against arm-v02 (RESULTS.md) |
|---|---|---|
| C1 | **Pass** (measured, observed). Full-bleed map, floating search card, grabber at y 865. A drag down at the smallest height left it at 865. All 40 markers present at the first capture | Same |
| C2 | **Pass** (measured). Heights 865, 459 and 70. Single drags settled on the next height. Three reversals within one touch settled at 865, 459 and 865 | Same heights and reversal results |
| C3 | **Pass** (measured). Smallest height: a pan of (−100, −90) pt moved a marker by (−90, −80), and a pinch-out took the visible markers from 35 to 1. Middle height: the pan moved the one visible marker off screen in the pan's direction, and a pinch-in took the visible markers from 0 to 16 | Same |
| C4 | **Pass** (measured). Middle height: a swipe up on the list grew the sheet to the largest height and left the list at 0 %. Largest height: a swipe scrolled the list to 42 % while the sheet stayed put. A swipe down scrolled back to the top first, and the next one moved the sheet to the middle height | Same |
| C5 | **Partial** (measured, code). Tapping the field at the smallest height moved the sheet to the largest height with keyboard focus. "falcon" gave 2 rows and "lake" the 6 places named Lake. Cancel returned to the **middle** height, not the smallest height where search began, 4 times out of 4 (twice in the checks, journey state 12, the second window). From the middle height, Cancel stayed at the middle height. The code still sets `.medium` on Cancel | Same defect, unchanged |
| C6 | **Pass** (measured, observed). Tapping the first row (Aspen Point) centred its marker at x 220, above the sheet, and showed its details (About and facts). Close returned to the list. Tapping an annotation (Silver Overlook) opened its details | Same |
| C7 | **Pass** (measured). The controls span y 773–838 at the smallest height and 366–430 at the middle height, and are hidden at the largest. They sit above the map-style card (512–577) while it is open. A tap 17 pt left of the Map Style glyph opened the card | Same frames |
| C8 (AX5) | **Partial** (observed). Search, rows, details and the category labels are reachable; the labels stay whole in a horizontally scrolling row. The row icons still fail: the glyph overflows its fixed disc and can't be read. The map controls do not scale | Same defects, unchanged |
| C9 | **Pass** (measured). All 40 markers are labelled, and rows read "name, kind · elevation". The controls are labelled (Map Style, Show All Places, the category buttons, Cancel Search, Clear Search, Close). The search field exposes only its placeholder, and some decorative symbols are exposed under their default names ("Binoculars, Filled", "Leaf") | Same |
| C10 | **Pass** (observed). In dark appearance the map and the glass sheet go dark and the text stays readable. The list card is an opaque dark panel | Same |
| C11 | **Pass** (measured). 3 of 3 launches alive at about 8 s (PID in the hierarchy and `pgrep`). No crash report and 0 faults. 36 errors, all from Apple subsystems: the same five messages with the same counts as both arms | Same |
| C12 | Measured: a 26.3 s attached Time Profiler recording over 3 drag cycles reported no hangs. The start conditions differ from the arms' traces (deviations above), so the two cannot be compared | Arms: 4 and 5 hangs, all in the first ~10 s |

**The agent's two fixes against this check**
- *The map moved when the sheet changed height:* **confirmed** (measured). Markers keep the same screen position at
  the smallest, middle and smallest heights in turn (Aspen Point at (263, 404) in all three). RESULTS.md has no
  matching measurement for arm-v02, whose code moved the map's bottom padding with the sheet (code).
- *The map ignored text search:* **not exercised.** No check presses Return, and at the largest height the sheet
  covers the map. Code: the markers now use the same filter as the list.

**Cold launch (step 1 method; labelled Sim/host and not comparable with step 1).** First launch after install: the map
was drawn at 13.2 s, with no tiles within 15 s. Relaunches: tiles at 6.1, 11.6, 11.5, 6.6 and 2.8 s, most of it on
the white launch screen. Under this load the screenshot polling itself slowed 1.5–7 times, so these times measure the
loaded Mac as much as the app. Step 1 measured arm-v02 at 3.8 s (map drawn) and 5.6 s (tiles) for its first launch and
1.3–1.5 s for relaunches; these numbers cannot be set against those. All 40 markers were present at the first capture
in C1 and in each C11 launch. No app-specific delay is established.

**What this shows (one run, no comparison claimed)**
- On C1–C11, the refined app behaves as arm-v02 did, with the same heights, the same passes and the same App
  defects: Cancel's return height, the AX5 row icons, the controls that don't scale, the placeholder-only field and
  the default symbol names.
- The refinement removed none of the assessor's arm-v02 findings and added no failure that C1–C11 detect. One of
  its own two fixes is confirmed; the other was not exercised.
- Two of the remaining defects sit in areas the agent listed as not checked (Dynamic Type, accessibility). The third,
  the Cancel height, sits in a journey it did run: it looked at the markers after Cancel, not at the sheet height.

## Rule notes (from the transcript and its notes)

- **Lock.** It held the shared lock for builds, `simctl` and device calls. It released the lock, then ran one last
  build under `lockf`, which is allowed after a release.
- **Simulator.** It used only `iPhone 18 Pro Max`, and builds used `-derivedDataPath ./DerivedData`.
- **Deviation from the folder rule.** Two build logs went to its Claude Code scratchpad under `/private/tmp`, outside
  the project folder.
- **Cleanup.** No `.hold` was left behind.

## Limits of this record

The "What it exercised" and "Defects it found" sections are as the agent reported them. The transcript shows the
device calls were made; the lead did not rerun the agent's own calls. The assessor's C1–C12 above ran afterwards, on
the owner's go-ahead of 2026-11-26 22:3x. They are one run of one build, not blind, and recorded here only, not in
RESULTS.md. The evidence stays private: the transcript, the agent's screenshots and hierarchies, the assessor's
captures and recording, and the run folder.

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
