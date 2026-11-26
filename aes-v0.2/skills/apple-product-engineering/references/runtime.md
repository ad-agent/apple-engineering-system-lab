# Runtime evaluation and refinement

## Four kinds of evidence

| Kind | Example | What it can establish |
|---|---|---|
| Source intent | "the pan cancels into the committed state" in code | Nothing about behavior |
| Model test | unit test of the progress model | The model's arithmetic |
| Runtime observation | UI test result, screenshot, recording, log line, trace | What the app did in that run, on that destination |
| Perceptual quality | a person judging feel, timing, haptic strength on a device | Feel. Not available to an agent |

Report each claim under the strongest kind you actually have, and say which runs it came from.

## Before the first edit

1. Read the project's rules on shared resources: build or simulator locks, which simulator to use, whether user data
   may be touched. They apply to `xcodebuild`, `simctl`, Xcode MCP tools and client simulator tools alike. If the
   rule is a lock wrapper around commands, an MCP action that builds, runs, tests, renders a preview or drives a
   device happens only while you hold that lock (for example a holder process started under the same lock for the
   duration of the MCP calls), or you use the command-line route instead.
2. Build and run the existing tests on the untouched baseline with a fresh result bundle:
   `xcodebuild test -scheme S -destination 'platform=iOS Simulator,id=<udid>' -resultBundlePath <new path> -derivedDataPath <scratch>`.
   Keep the log. Note every failure, skipped test, runtime warning and stall. These are the baseline's, not yours.
3. Never erase a simulator, uninstall the app or delete its container to get a clean state. Use the app's test
   fixtures, launch arguments or a separate install; if that is impossible, stop and ask.

## The refinement loop

1. Run the app on the agreed destination and walk each acceptance condition as a user would, plus the neighbouring
   states listed in preservation.md. Use previews (`RenderPreview` in Xcode MCP) for layout variants such as text
   size, locale and appearance; use the running app for behavior, gestures, focus, keyboard and persistence.
2. Capture: screenshots of named states (`xcrun simctl io <udid> screenshot`), a recording of each gesture
   (`xcrun simctl io <udid> recordVideo --codec h264 out.mov`, stopped with Ctrl-C/SIGINT), the console
   (`GetConsoleOutput`, or `xcrun simctl spawn <udid> log stream --predicate 'process == "App"'`).
3. Look at the captures. For motion, extract frames (`ffmpeg -i out.mov -vf fps=30 f%04d.png`) and check the
   phases in interaction.md; measure an edge across frames rather than judging by eye
   ([examples/edge-track](../examples/edge-track/)).
4. Write each problem as observation → cause (if established) → change → re-check. Fix the most user-visible
   first. Re-run only what the change can affect, then the full suite once at the end.
5. Stop when every acceptance condition has runtime evidence, or the budget is spent, or a blocker needs the owner.
   List what remains unverified.

## Which tool observes what

| Need | Tool |
|---|---|
| API declaration, availability | SDK `.swiftinterface` / headers; Xcode MCP `DocumentationSearch` |
| Build errors, warnings | `xcodebuild` log; Xcode MCP `BuildProject`, `GetBuildLog`, `XcodeRefreshCodeIssuesInFile` |
| Layout of one view in many configurations | Xcode MCP `RenderPreview` (locale, variants, device) |
| Test results with attachments | `xcodebuild test -resultBundlePath`, then `xcrun xcresulttool get test-results summary --path R` / `tests` |
| Drive the running app | XCUITest; Xcode MCP `DeviceInteractionSynthesize` (returns screenshot and UI hierarchy); the client's simulator tool (tap, swipe, multi-point `touch_path`) |
| Logs and runtime issues | Xcode MCP `GetConsoleOutput`; `log stream`; the test log |
| Hangs, hitches, CPU, memory | `xcrun xctrace` (read Apple's `xctrace` skill in Xcode's resources first); Xcode MCP `InvokeDebuggerCommand` for a paused process |

Xcode MCP tools need a one-time approval in Xcode for the agent (the first `XcodeOpenWorkspace` or
`XcodeNewProject` call asks the user). Until that approval exists, use the command-line route.

## Diagnosing what you observe

**Pre-existing or introduced?** Run the same test, same destination, same fixture on an export of the baseline
commit (`git worktree add` or `git archive`). Fails there too: pre-existing. Then keep the check: wrap it in
`XCTExpectFailure("pre-existing: <defect>, seen on <commit>")`, or leave it failing and report it. Do not delete or
loosen the assertion. Experimental B removed its reopened-note text assertion after proving the defect
pre-existing; an expected failure would have kept the evidence and alerted on a fix.

**XCTest "App animations complete notification not received".** XCUITest waits for the app to go idle after each
action; this message means something kept animating for about a minute. Causes seen in practice: a
`TimelineView(.animation)` or display link left running, a repeating animation, a value that changes every layout
pass and re-triggers `.animation(_:value:)`, a geometry feedback loop. Method: rerun the single test and see if it
recurs; record the screen during the stall and look for anything that moves; add `let _ = Self._printChanges()` to
suspect view bodies in a debug build and read which keeps updating; compare with the baseline run. Count stalls per
run and report them even if the run passed. Experimental B's final run had four stalls of ~60 s, two right after
reveal interactions, and did not report them as possibly introduced.

**Runtime warnings** (purple runtime issues; in logs as plain lines). `Invalid frame dimension (negative or
non-finite)` means a `.frame` received a negative or NaN size, usually from arithmetic on a zero size during the
first layout pass (`width - inset`, `distance / width`). Search the frame modifiers fed by computed values, log the
value, and fix the arithmetic at its source. Compare the count with the baseline: Experimental B's baseline had 4,
its final run 5. Report the change.

**Performance regressions.** Profile the same build configuration, device, fixture and journey before and after,
with `xcrun xctrace record --template 'Animation Hitches'` (or `Time Profiler`) and the same interval. Separate
cold launch from warm repetitions. Without measurements, say the performance is unmeasured.

## Compliance is separate from autonomy

"No human interventions" means nobody had to help. Whether the run followed the operator's rules (locks, simulator,
deletion method, working folder, time limit) is a separate line in the report, with each deviation listed.
