# Runtime criticism

## Evidence and what it can establish

| Kind | Example | What it can establish |
|---|---|---|
| Source intent | "Cancel restores the previous height" in code | Nothing about behaviour |
| Test | unit test of the model; UI test result | What the test asserts, on that destination |
| Runtime observation | hierarchy, screenshot, recording, console line, trace | What the app did in that run |
| Perceptual quality | a person judging feel, timing, haptics on a device | Feel. Not available to an agent |

The kinds complement each other: the hierarchy gives state (frames, focus, values, counts); a screenshot gives
colour, clipping and overlap; a recording gives motion; the console and traces give warnings and time. Report each
claim under the strongest kind you have. A tool that returned success says the command ran, not that the user got
what the journey promises.

## Before the first edit

1. Read the project's rules on shared resources: build or simulator locks, which simulator, whether user data may be
   touched. They apply to `xcodebuild`, `simctl`, Xcode MCP tools and client simulator tools alike. If the rule is a
   lock wrapper around commands, an MCP action that builds, runs, tests or drives a device happens only while you
   hold that lock (for example a holder process started under the same lock), or you use the command-line route.
2. Build and run the existing tests on the untouched baseline with a fresh result bundle and a scratch
   `-derivedDataPath`. Keep the log; note every failure, skip, runtime warning and stall. These are the baseline's.
3. Never erase a simulator, uninstall the app or delete its container to get a clean state. Use the app's fixtures,
   launch arguments or a separate install; if that is impossible, ask.

## Choose the checks for the task

| Task | Proportionate verification |
|---|---|
| Model logic, a bug with no visible change | Unit test, one run of the affected journey |
| Layout or visual change | Running app at default size, at `accessibility-extra-extra-extra-large` and in dark; previews for many variants |
| A journey, navigation or state change | Each journey from two or more starting states, hierarchy compared before and after every step |
| A continuous gesture or transition | The above, plus multi-point drags with reversal and a recording measured frame by frame (interaction.md) |
| A suspected slowness or hang | Measure first: repeated cold launches, timed captures, then `xctrace` (Apple's skill) |

Pick from this, do not run everything. A one-line string fix does not need an accessibility pass; a new screen does.

## Driving the app

Load Apple's `device-interaction` skill (SKILL.md §1) and follow its session lifecycle, command syntax, timing and
"judging success" sections. Verified corrections for Xcode 27.2 (build 27B52), where the tools differ from the text:

- The skill calls the action tool `DeviceEventSynthesize`; the tool is `DeviceInteractionSynthesize`.
- The skill and `DeviceInteractionStartSession`'s reply tell the main agent to hand interaction to a subagent.
  Nothing enforces it; calling the tools directly works. Do not add an agent for it.
- "Completes once animations are done" did not always hold: a capture straight after a tap came before the
  transition ended. Recapture once, or append `w 1`.
- In a session without a workspace (`DeviceInteractionStartSession` with a simulator name or UDID) `applicationState`
  reads `NotRun` while the app runs; use the PID in the hierarchy. `GetConsoleOutput` needs an open workspace; use
  `xcrun simctl spawn <udid> log stream --predicate 'process == "App"'` otherwise.
- `sender keyboard kbd <text>` types and must end the command chain. No on-screen keyboard appears in the hierarchy
  or screenshot, so "the keyboard is shown" cannot be checked this way.
- The hierarchy can report an image button with its glyph's frame, not its 44 pt hit area.
- `xcrun mcpbridge run-agent skills export` omitted the accessibility skills on this Xcode; use `plugin path`.

Verified command forms: `mt [220 865] 0.1 [220 865] 0.5 [220 520] 0.4` (drag with hold), adding a further keyframe
reverses within one touch; `t x y f x2 y2 0.3` (swipe); `drag x1 y1 x2 y2`; two-point `mt [a b, c d] …` (pinch).

Other routes, for when the device tools are missing or fail: XCUITest (`press(forDuration:thenDragTo:)` for one
straight segment, `typeText`), the client's own simulator tool, `xcrun simctl io <udid> screenshot` and
`recordVideo --codec h264 out.mov` (stop with SIGINT).

## The criticism loop

1. **Journeys.** For each primary journey written in SKILL.md step 2, run it from more than one starting state (for a
   sheet: each height; for a list: empty, short, scrolled; for a form: blank and edited). Capture first. After every
   action compare the new hierarchy with the previous one by script: frames, labels, values, focus, element counts.
   Compare the final state with the written expected end state. "Something changed" is not a pass.
2. **System settings in the running app.** Walk the primary journeys once at
   `xcrun simctl ui <udid> content_size accessibility-extra-extra-extra-large` and once with
   `xcrun simctl ui <udid> appearance dark`, then restore the values you read beforehand. Look for truncation,
   broken words, overlapping or clipped controls, fixed-size icons, unreadable colours. Read the hierarchy's labels
   in order as VoiceOver would: every control named in words, no symbol names (`"plus.circle"`), no placeholder used
   as the only label. Apple's three accessibility skills audit the source for the causes; use them to fix.
   Reduce Motion is not in `simctl ui`; set it in the simulator's Settings > Accessibility > Motion and note it.
3. **Responsiveness.** If anything feels or looks slow, measure before you report it: several cold launches timed
   the same way, timed captures around the action, then `xctrace` with Apple's skill. Record the Mac's load average;
   numbers from a busy Mac are not comparable.
4. **Console.** Read it while running the journeys. Every warning is reported; a new one is investigated.
5. **Fix and re-check.** Write each problem as observation → cause (if established) → change → re-check. Fix the most
   user-visible first; re-run what the change can affect, then the full suite once at the end. Then go back to the
   completion rule in SKILL.md §3.

## Diagnosing what you observe

**Pre-existing or introduced?** Run the same check on an export of the baseline commit (`git worktree add` or
`git archive`). Fails there too: pre-existing. Keep the check: `XCTExpectFailure("pre-existing: <defect>, seen on
<commit>")`, or leave it failing and report it.

**XCTest "App animations complete notification not received".** Something kept animating for about a minute: a
`TimelineView(.animation)` or display link left running, a repeating animation, a value that changes every layout
pass and re-triggers `.animation(_:value:)`, a geometry feedback loop. Rerun the single test; record the screen during
the stall and look for movement; add `let _ = Self._printChanges()` to suspect views in a debug build. Count stalls
per run and report them even if the run passed.

**`Invalid frame dimension (negative or non-finite)`.** A `.frame` got a negative or NaN size, usually from
arithmetic on a zero size in the first layout pass. Log the value at the modifier and fix it at its source. Compare
the count with the baseline.

**Performance regressions.** Same build configuration, device, fixture, journey and interval before and after;
cold launch separate from warm repetitions. Without measurements, say the performance is unmeasured.

## Compliance is separate from autonomy

"No human interventions" means nobody had to help. Whether the run followed the operator's rules (locks, simulator,
deletion method, working folder, time limit) is a separate line in the report, with each deviation listed.
