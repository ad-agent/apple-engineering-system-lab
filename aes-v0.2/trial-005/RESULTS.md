# Trial 005: results (one pair)

Status 2026-11-26 19:2x: both arms ran and finished, and all scoring is below: transcript, code, `NOTES.md` and the
runtime checks C1–C12 (run 18:10–18:27 in one lead-held lock window on `iPhone 18 Pro Max`). Director Decision 006
step 1 is complete: interaction recordings, a matched screenshot set, a cold-launch series and a label on every
finding were added in a second lock window (19:00–19:10), in the last section. One pair can show failures and
differences in behaviour. It cannot show that either arm's configuration is better, and nothing here claims that.

The arm folders, transcripts and screenshots stay in `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/`
and are not published: arm-v02 saved frames from the participant copy of the private recording in `work/ref/`.

## Runs

| | arm-control | arm-v02 |
|---|---|---|
| Prompt | `Read OBJECTIVE.md and CLAUDE.md …` | `/apple-product-engineering Read OBJECTIVE.md …` |
| Wall time (local, +01:00) | 17:10:10–17:17:15 | 17:18:07–17:27:02 |
| Duration, turns, tool calls | 423 s, 72, 71 | 533 s, 88, 86 |
| Reported cost (API-equivalent) | 2.20 USD | 2.75 USD |
| 5-hour plan window used (approx.) | ~17 % | ~20 % (22 → 44 % includes the lead's own use) |
| Ended by | itself (`success`) | itself (`success`) |
| Participant commit | `6c5097c` | `7caa43b` |
| Lead end-of-arm commit (in the arm) | `36c91ba` | `4207fed` |

Neither arm used more than 9 of its 60 minutes.

## Deviations and environment notes (same for both arms unless stated)

1. **Launch environment.** Both arms ran from `env -i` with only HOME, USER, LOGNAME, SHELL, PATH, LANG, TMPDIR and
   `TERM=dumb`, so no desktop-session variables reached them. The command was otherwise exactly ARMS.md's.
2. **Usage rule.** ARMS.md says to start an arm only with room for 60 minutes. arm-control used ~17 % of a Pro
   5-hour window in 7 minutes, so no window can hold 60 minutes at that rate. The lead started arm-v02 at 22 % (78 %
   room, about 4× arm-control's use) and would have voided and rerun it if a limit had cut it. None did.
3. **Xcode folder approval was never exercised.** Xcode allowed only the `starter` folder. Neither arm called
   `XcodeOpenWorkspace`; both built with `xcodebuild` and drove the simulator with `simctl` and
   `DeviceInteraction*`, which need no workspace. So there was no prompt and no intervention, and the
   "`XcodeSwitchRunDestination` after every open" rule had nothing to apply to.
4. **Shared Xcode MCP state.** arm-v02's first `DeviceInteractionStartSession` used the ID `Waypoints Walk`, the same
   ID arm-control had used, and Xcode refused it as recently used; arm-v02 retried with another ID (one extra call).
5. **Device-interaction syntax.** The tool's errors say "review … device-interaction skill", a skill bundled with
   Xcode that neither arm had. Both arms guessed the same wrong commands (`help`, `type`, `k`, `s`, `d`, `swipe`).
   arm-control then found `drag` and made four successful drags; arm-v02 never made a drag. Neither typed text
   (`sender keyboard kbd` is the syntax).
6. **Lead end-of-arm commits** (`git add -A`, as ARMS.md says) also added the frozen inputs (reference copy,
   `CLAUDE.md`, `OBJECTIVE.md`, and in arm-v02 the skill) to each arm's local git. Local only. Diffs below exclude them.
7. **Not blind.** The lead launched both arms and knows which is which.
8. Human interventions: **0 in both arms.**

## Rule compliance (from the transcripts)

| Rule | arm-control | arm-v02 |
|---|---|---|
| Lock: every build, `simctl`, `xctrace` and device call inside a `.hold` window | Yes (window calls 13–69, released) | Yes (calls 16–84, released) |
| No `lockf` prefix while holding | Yes | Yes |
| Simulator `iPhone 18 Pro Max` (UDID 7EF1C8CB…) only | Yes | Yes |
| Writes only inside the arm folder | Yes | Yes. It self-reports one `ls` of Xcode's bundled agent-guidance folder (outside the project; nothing read) |
| `XcodeSwitchRunDestination` after each open | n/a (no opens) | n/a (no opens) |
| DerivedData | `./DerivedData` (git-ignored) | `./DerivedData` (git-ignored) |

## Knowledge consumption (arm-v02 only)

The leading `/apple-product-engineering` expanded `SKILL.md` into the prompt (`-p` does not echo it into the
stream, so this is inferred from what followed). The participant then read 5 of the 7 references with `cat`:
`reference-analysis.md`, `native.md`, `runtime.md`, `product.md`, `interaction.md`. It did not read `haptics.md`
or `preservation.md` or either example. arm-control's skill list did not contain the skill (checked in its `init` event).

## Native integration and architecture (from code)

| | arm-control | arm-v02 |
|---|---|---|
| App Swift files, lines | 5 files, 750 | 5 files, 701 |
| Root sheet | `.sheet` + `presentationDetents` (84 pt peek, medium, large), `presentationBackgroundInteraction` up to medium, `interactiveDismissDisabled` | same pattern (80 pt, medium, large) |
| Map | SwiftUI `Map`, `MapCameraPosition`, `mapControls`, `mapStyle` | same |
| Custom gestures or blur | none | none |
| Glass | one `glassEffect` (control capsule) | one `glassEffect` (control capsule) |
| Controls track the sheet | `onGeometryChange` on the sheet's top edge | `onGeometryChange` on the sheet content's global `minY` |
| Search | `TextField` (not `.searchable`) | `TextField`, with a reason given (`.searchable` needs a navigation bar) |
| Map-style surface | panel that replaces the root sheet | a second sheet stacked over the root sheet |
| Accessibility labels/hints in code | 0 | 7 |
| State | 10 `@State`, 6 `@Binding`, no `@Observable` | 11 `@State`, 10 `@Binding`, 1 `@Environment`, no `@Observable` |
| Look Around | not built (stated as a deliberate omission) | not built (stated) |
| Other files committed | `NOTES.md` | `NOTES.md`, 18 screenshots and a contact sheet under `work/`, `work/snap.sh` |

## Reference comprehension (`NOTES.md` against CHECKS.md O1–O8, I1–I3)

✓ described, ◐ partly, ✗ missing or misclassified.

| | arm-control | arm-v02 |
|---|---|---|
| O1 full-bleed map, root sheet always present | ✓ | ✓ (stated in the build summary) |
| O2 smallest height: floating inset card, search + account | ✓ (no account button) | ✓ (with avatar) |
| O3 further heights (Places, Guides), largest dims the map | ◐ three heights, content not named, no dimming | ◐ Places and Guides named, no dimming |
| O4 search: full height, keyboard, suggestions, X back | ✓ | ✓ |
| O5 controls top-right move with the sheet; Look Around control at left | ◐ left control not noted | ✓ |
| O6 map pans while the sheet rests at a middle height | ✓ ("usable around them", as observed) | ✗ listed as inferred ("not demonstrated by touches") |
| O7 secondary card replaces the root sheet, close, taller state, live map change, restores | ◐ all but the taller state | ◐ no taller state; says the map changes after closing |
| O8 Look Around panel | ✗ named only as omitted | ✗ named only as omitted |
| Observed and inferred kept apart | Yes | Yes, plus an "Unknown" list |
| I1 detents with background interaction | built, not named as an inference | ◐ background interaction named as inferred |
| I2 system glass | described as observed "glass" | described as observed "glass" |
| I3 secondary card keeps the root state | as observed ("earlier height") | as observed ("where it was") |

## Self-reported verification (what each arm says it ran)

| | arm-control | arm-v02 |
|---|---|---|
| Sheet drags | claims collapsed and large drags; transcript shows 4 accepted `drag` commands | none; says so and lists it as not checked |
| Typing a query | not verified (says so) | not verified (says so) |
| Console check | none reported | yes: no SwiftUI runtime warnings; lists system noise |
| Cold-launch blank screen | not reported | reported (5+ s, twice), not profiled |
| Dynamic Type, dark mode, VoiceOver | not checked (says so) | not checked (says so) |

## Runtime checks C1–C12 (assessor)

**How they were run.** 2026-11-26 18:10:36–18:26:39, in one lock window: a holder process owned
`/tmp/edraft-checks.lock` for the whole window, and nothing else ran in the heavy lane. Simulator: `iPhone 18 Pro Max`
only. Each arm's committed source (`36c91ba` and `4207fed`) was exported with `git archive` and built with
`xcodebuild -configuration Debug -derivedDataPath <trial folder>/assess/<arm>/DD`. Both builds succeeded with no
compiler warnings, in 9.4 s and 6.1 s. The arms share a bundle ID, so each was installed with `simctl` only after the
other was uninstalled, then launched with `simctl launch`. Each arm was driven through `tools/m` (`mcpd.py` →
`xcrun mcpbridge`) in its own fresh `DeviceInteractionStartSession` ("Trial 005 Assess Control", "Trial 005 Assess
V02"). After every `DeviceInteractionSynthesize` step a hierarchy was captured and parsed by script; the assessor
looked at nine screenshots or crops. Dynamic Type (`large`) and appearance (`light`) were recorded first and restored
after each arm, and the final state was checked. All evidence stays unpublished in
`~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/assess/`. The assessor knew which arm was which, so the
checks were not blind.

**Evidence labels.** **measured**: numbers read by script from hierarchy frames, the unified log or a trace.
**observed**: the assessor's reading of a screenshot. **code**: confirmed in the arm's source. **asserted**: an
inference that was not checked directly.

**Deviations from `assessor/CHECKS.md`**
- C11 read the simulator's unified log (`simctl spawn … log show`, process `Waypoints`, error and fault) in place of
  `GetConsoleOutput`. That tool refused because no Xcode workspace was open ("workspaceIdentifier is required"), and
  the workspaces were left closed to avoid Xcode's destination switching (TOOLS.md).
- In a session without a workspace, every capture reported `applicationState: NotRun` even though the app was in
  front and responding. Liveness came from the PID in the hierarchy and from `ps`.
- A marker's accessibility frame does not change when the marker is selected, so selection was judged from
  screenshots.
- A capture taken straight after a tap can come before the animation ends. After the first such miss (arm-control
  C6: the tap had worked), taps were followed by `w 1`.

| # | arm-control | arm-v02 |
|---|---|---|
| C1 | **Pass** (measured, observed). Full-bleed map under the status bar; inset floating search card; grabber at y 851. A drag down at the smallest height left it at 851 | **Pass** (measured, observed). The same, with the grabber at y 855. The first launch after install showed the empty map grid at ~3 s and tiles by ~11 s. All three later launches had tiles at the first capture (measured from screenshot colour) |
| C2 | **Pass** (measured). Three resting heights, with the grabber at 851, 447 and 58. Single drags up and down settled on the next height. Three reversals within one touch settled at 851, 447 and 851 | **Pass** (measured). Heights 855, 447 and 58. The same drags and reversals settled on the same heights |
| C3 | **Pass** (measured). Smallest height: a pan of (−100, −90) pt moved a marker by (−92, −81), and a pinch-out took the visible markers from 40 to 1. Middle height: a pan moved the map, and a pinch-in took the visible markers from 1 to 18 | **Pass** (measured). Smallest height: the marker moved by (−95, −78); pinch 40 → 1. Middle height: the pan moved the map; pinch 1 → 18 |
| C4 | **Pass** (measured). At the middle height, a swipe up on the list grew the sheet to the largest height and left the list at 0 %. At the largest height, a swipe scrolled the list (43 %) while the sheet stayed put. A swipe down scrolled back to the top first | **Pass** (measured). The same behaviour; the list scrolled to 42 % |
| C5 | **Pass** (measured). From the smallest height, tapping the field moved the sheet to the largest height with keyboard focus. "falcon" gave 2 rows. "lake" gave 12, because it also matches the kind "Lake & Spring". Cancel returned to the smallest height. The on-screen keyboard was not captured (the hierarchy shows focus only) | **Partial** (measured, code). Expanding, focus and filtering pass: "falcon" gave 2 rows and "lake" the 6 places named Lake. Cancel returned to the **middle** height, not the smallest height where search began. This happened twice in a row, and the code sets `detent = .medium` on Cancel (`PlaceSheet.swift:96`) |
| C6 | **Pass** (measured, observed). Tapping a row recentred the map (the marker at x 220, above the sheet) and enlarged the marker. The sheet showed details: Directions, Share, facts and Nearby. Close returned to the list. Tapping an annotation opened its details | **Pass** (measured, observed). The same: the marker centred at x 220 and enlarged; details with About, facts and Nearby, but no Directions or Share. Close returned to the list. Tapping an annotation opened its details |
| C7 | **Pass** (measured). Controls span y 742–835 at the smallest height (sheet at 851) and 339–431 at the middle height (447), and are hidden at the largest. They move with the sheet and stay above the details card | **Pass** (measured). Controls span 773–838 and 366–430, are hidden at the largest height, and sit above the map-style card. The hierarchy gives glyph-sized frames (19×18 and 22×22), but a tap 17 pt off the glyph opened Map Style, so the hit area is the 44 pt frame |
| C8 (AX5) | **Partial** (observed, measured). Rows, search and details are reachable and wrap. The Explore category labels truncate ("Trai Ih…", "Vie w…"), and the Directions and Share buttons break words ("Di-rect ion", "Sh are"). The map controls do not scale | **Partial** (observed, code). Rows, search, details and the category labels are reachable and unclipped; the labels run full width in a horizontally scrolling row. The row icons fail: the symbol uses `.font(.body)` inside a fixed 34×34 circle, so at AX5 the white glyph overflows its coloured disc and the icon can't be read. The map controls do not scale |
| C9 | **Pass** (measured). All 40 markers are labelled by name, and rows read "name, kind · elevation". Labelled controls: Map Modes, Show All Places, Cancel Search, Clear, Close, Directions, Share. The search field exposes only its placeholder, and some decorative symbols are exposed under their default names ("Binoculars, Filled") | **Pass** (measured). All 40 markers labelled, and rows read the same way. Labelled controls: Map Style, Show All Places, Cancel Search, Clear Search, Close, the three style buttons, and the Labels and 3D Terrain switches. The same placeholder-only field and default symbol names |
| C10 | **Pass** (observed). In dark appearance the map and the glass sheet go dark and the text stays readable | **Pass** (observed). The same. The list card is an opaque dark panel inside the glass sheet |
| C11 | **Pass** (measured). All 3 launches were alive at ~9 s, and one process (PID 89529) lasted through C1–C10. No crash report and 0 faults. 36 errors (12 per launch), all from Apple subsystems: CoreGraphics "clip: empty path" ×8, GeoServices "default.csv", CoreAnimation ×2, BoardServices | **Pass** (measured). The same: 3 of 3 launches alive, PID 93064 throughout, no crash report and 0 faults. The same 36 errors: the same five messages with the same counts |
| C12 | Measured: a 25.9 s attached Time Profiler recording over 3 drag cycles. 5 hangs: 2 Hangs (551–619 ms) and 3 Microhangs (263–445 ms), between 4.0 s and 10.1 s. Main-thread CPU during them was 5–20 %, and the heaviest stack is `App.main` (system libraries flattened) | Measured: a 26.3 s recording. 4 hangs: 1 Hang (1.71 s) and 3 Microhangs (428–431 ms), between 3.9 s and 10.4 s. Main-thread CPU 5–24 %; the heaviest stack is `App.main` |

**Reading C12 (asserted).** In both arms every hang falls in the first ~10 s of the trace. Going by command timing,
that span covers the attach, the first MCP activation of the app and the first drag cycle; no hang falls in cycles 2
or 3. Low main-thread CPU and flattened stacks don't point at app code. The simulator cannot measure hitches
(MCP-VERIFIED.md), and one recording per arm can't separate the arms on performance.

**What the runtime checks show (measured, one pair, no superiority claim)**
- Both arms passed C1–C4, C6, C7 and C9–C11 with the same system-sheet behaviour: the same heights, the same reversal
  results and the same log noise.
- Arm-v02 failed one part of C5: Cancel goes to the middle height. Arm-control's search also matches kinds.
- Both arms are partial on C8, with different defects: arm-control truncates category labels and breaks button
  words; arm-v02's row icons overflow.
- Not a numbered check: arm-control's Show All Places at the middle height frames the places in the whole screen,
  leaving 19 of 40 markers under the sheet. Arm-v02 fits all 40 above it (measured).
- Self-reports against the runtime checks: arm-v02's reported blank cold launch appeared once, on the first launch
  after install. Arm-control's claimed sheet drags hold. Neither arm checked Dynamic Type, and both turned out
  partial at AX5.

## Decision 006 step 1: recordings, matched screenshots, cold launch, finding labels

**How it was run.** 2026-11-26 19:00:31–19:10, in a second lead-held lock window: a holder process
(`turn-holder.sh` + `quiet.sh`) owned `/tmp/edraft-checks.lock`, and the heavy lane was otherwise idle. Simulator:
`iPhone 18 Pro Max` only. The same builds of `36c91ba` and `4207fed` as above were used again, without rebuilding,
and the participant sources were not touched. For each arm, control first: uninstall, install, a cold-launch series
of six launches without MCP, then a fresh MCP device session ("Trial 005 Step1 Control", "Trial 005 Step1 V02")
drove 24 matched states while `simctl io … recordVideo` recorded the screen (control 72 s, v02 69 s). Tap targets
were found by label or type in the previous hierarchy, so each arm got the same action on its own layout. Every
state has the MCP screenshot and hierarchy. Dynamic Type and appearance were changed only inside the journey and
were `large` and `light` again at the end (checked). Arm-v02 is left installed. The evidence stays unpublished in
`~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/assess/step1/` (scripts in `bin/`, per arm `cold/` and
`journey/`). The screenshots contain Apple Maps tiles of a real area under the synthetic places, so none are
published here.

**Matched states** (measured: sheet grabber centre y from the hierarchy; peek ≈ 862/865, medium 459, large 70).
The two arms ended in the same state at every step, except the two rows marked ◆.

| # | State | arm-control | arm-v02 |
|---|---|---|---|
| 1–2 | Launch at peek; drag down at peek | 862 → 862 (sheet stays) | 865 → 865 (sheet stays) |
| 3–5 | Drag to medium, to large, back to medium | 459, 70, 459 | 459, 70, 459 |
| 6 | Reversal in one touch from medium (up to y 100, then down to y 800) | settles at peek | settles at peek |
| 7–9 | Map pan at peek; drag to medium and pan; back to peek | panned; 459; 862 | panned; 459; 865 |
| 10–11 | Tap search at peek; type "falcon" | large, field focused; 2 rows | large, field focused; 2 rows |
| 12 ◆ | Cancel search | **peek** (where search began) | **medium**, a third reproduction of the C5 defect |
| 13–15 | Medium list; tap the first row (Aspen Point); Close | details at medium; list | details at medium; list |
| 16 ◆ | Tap a visible annotation | Silver Falls → details | Aspen Point → details (Silver Falls was off screen) |
| 17–19 | Close; open map style; Close | list; Map Modes card; list | list; Map Style card replaces the sheet; list |
| 20 | Dark appearance at medium | readable | readable; the list card is an opaque dark panel |
| 21–24 | AX5 at medium; large; first row's details; Close | labels truncate ("Trai Ih…"); Directions and Share break mid-word | category labels whole; row icons overflow their discs |

**Cold launch** (measured: `simctl io screenshot` polled every ~0.48 s for 15 s after `simctl launch`. Each frame
is classed by the brightness and colour count of the map band: launch screen, flat map with no tiles yet, empty
grid, or tiles. The time resolution is one polling interval.)

| Launch | arm-control: map drawn / tiles | arm-v02: map drawn / tiles |
|---|---|---|
| 1, first after install | 3.5 s / 4.6 s (launch screen until ~3.1 s) | 3.8 s / 5.6 s (launch screen until ~3.3 s, empty grid at 5.1 s) |
| 2–6, relaunch after `simctl terminate` | tiles at 1.8, 1.6, 1.4, 1.4, 1.7 s | tiles at 1.5, 1.5, 1.3, 1.4, 1.5 s |

In both arms, the first launch after install takes about 3–4 s longer than later launches, and most of that is the
white launch screen. The ~11 s empty grid that arm-v02 showed once at 18:1x (C1) did not come back: tiles appeared
at 5.6 s on the first launch after install. That earlier launch came straight after install, with the MCP session
activating the app, and was not repeated. So the evidence does not show an app-specific cold-launch defect in
either arm: one first launch per arm, five relaunches.

**Labels on every finding.** **App**: a defect or behaviour of the arm's code. **Tool**: the Xcode MCP tools or
their hierarchy. **Sim**: the simulator or the Mac it runs on. **Auto**: the assessor's automation or timing.

| Finding | Arm | Label | Evidence |
|---|---|---|---|
| Cancel search returns to the middle height, not the height where search began | v02 | **App** | measured three times (C5 twice, state 12 once); code `PlaceSheet.swift:96` sets `.medium` |
| Search also matches the kind ("lake" → 12 rows); C5 asks for name filtering | control | **App** (behaviour beyond the spec, not a failure) | measured |
| AX5: Explore category labels truncate; Directions and Share break mid-word | control | **App** | observed in C8 and states 22–23 |
| AX5: row icon glyphs overflow their fixed 34×34 discs | v02 | **App** | observed in C8 and states 21–22; code |
| AX5: the floating map controls do not scale | both | **App** (minor) | observed |
| Search field exposes only its placeholder; some decorative symbols are exposed under default names | both | **App** (minor) | hierarchy labels |
| Show All Places at the middle height leaves 19 of 40 markers under the sheet | control | **App** | measured |
| Nearby distances use ft/mi while elevation uses m | control | **App** (minor) | observed |
| ~11 s empty map grid on one first launch after install | v02 | **Not reproduced**: first-launch cost common to both arms (Sim), plus tile loading | cold-launch series above |
| Empty grid one second after choosing a row (state 14), tiles in the next state | v02 | **Auto/Sim**: the capture came before tiles loaded at the closer zoom | observed; state 15 has tiles |
| `applicationState: NotRun` while the app is in front and responding | both | **Tool** (session without a workspace) | measured: PID in the hierarchy, `ps` |
| A selected marker's accessibility frame does not change size | both | **Tool/system**: both arms use the system `Marker`, whose selection is drawn by MapKit | code; screenshots show the enlargement |
| Map-control frames are glyph-sized (19×18, 22×22) in the hierarchy | v02 | **Tool** (hierarchy reports the image) | code gives the button label a 44×44 frame; a tap 17 pt off the glyph worked |
| A capture straight after a tap can come before the animation ends | both | **Auto** | arm-control C6 needed a recapture; every later tap waits 1 s |
| No on-screen keyboard in screenshots or hierarchy while the field has focus | both | **Sim/Auto** (cause not established; typing works through `sender keyboard kbd`) | hierarchy shows `Keyboard Focused`; C5's "shows the keyboard" stays unverified for both arms |
| `GetConsoleOutput` refuses without an open workspace | both | **Tool** | C11 deviation above |
| 12 errors per launch from Apple subsystems, the same in both arms | both | **Sim/system**, not the app | C11 |
| Hangs only in the first ~10 s of each C12 trace (attach, first MCP activation, first cycle) | both | **Not separable** with this evidence (asserted: tool activation or launch) | C12; the cold-launch series used no MCP and saw no stall after tiles, but screenshots cannot measure hangs |
| Hitches | both | **Sim**: not measurable on the simulator | MCP-VERIFIED.md |

**Limits of this evidence.** The recordings show that the sheet settles and the map moves. They do not show how
the gestures feel on a device, or the quality of the animation curves, and no claim is made about either. The
gestures are synthesized, with fixed timings.
