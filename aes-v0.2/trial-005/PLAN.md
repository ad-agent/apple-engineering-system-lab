# Trial 005: plan (prepared, not yet frozen)

Status: **Task B superseded by ARMS.md (frozen 2026-11-26; fresh project per Decision 005, not yet run).** Task A below is unchanged, design only.

Earlier status: **design only.** The fixture app, the reference recording and the baseline defect run do not exist yet. No
participant has run. Nothing here is evidence that v0.2 improves application quality.

One trial, two tasks on one fresh fixture, so Assignment 004's transfer task and the reference-driven challenge share
one app, one freeze and one protocol.

## Fixture: "Trailhead" (new, never used while developing AES)

- iOS 18+ SwiftUI app, ~600 lines, no third-party code. 200 fictional trails (name, region, length, difficulty,
  dogs allowed, latitude/longitude) in a bundled JSON; favorites persisted to a JSON file in Application Support.
- Screens: `NavigationStack` list with `.searchable`; trail detail; a toolbar filter button that opens a `.sheet` at
  `.presentationDetents([.medium])` with 9 filter options in a fixed-height `VStack` (not a `List`) and an Apply
  button pinned below it.
- Public tests: model tests for filtering and favorites; one UI test that filters at the default text size.
- Launch argument `-TrailheadFixture <name>` selects a fixture library in the app's container, so trials never touch
  installed user data.
- **Author:** not an AES participant session and not a session that has read assessor material for this trial: an
  outside builder (Grok, per the owner's builder rule) from the spec above, reviewed by the lead for the defect only.

## Task A (transfer, from `evaluation/holdouts.md`): accessibility filter sheet

- Participant brief: "Make the existing filter sheet usable at accessibility text sizes while keeping its current
  compact appearance at default sizes."
- Baseline defect to reproduce before freezing: at `AX5` (`xcrun simctl ui <udid> content_size accessibility-extra-extra-extra-large`)
  the last two options and Apply are clipped and unreachable; VoiceOver cannot reach Apply. If the baseline already
  passes, change the fixture before any participant sees it.
- Assessor-only checks: default and AX5; select the last option and apply; dismiss an unapplied change (result list
  unchanged); VoiceOver order reaches every option and Apply; result membership correct; favorites after relaunch;
  default-size screenshots match the baseline's (preservation).

## Task B (reference-driven creation): map with a persistent sheet

- Primary input: a 10–15 s simulator recording of Apple Maps (the system app on the shared `iPhone 18 Pro Max`)
  dragging its place sheet between small, medium and large and scrolling inside it, plus one still. Captured by the
  operator; not published (another product's UI), SHA-256 recorded.
- Objective given to participants: "Add a map to Trailhead that works like the reference: the trail list lives in a
  sheet over the map, the map stays usable, and choosing a trail moves the map to it."
- Assessor-only checks: three resting heights and drags between them, including a reversal (client `touch_path`);
  map pans and zooms while the sheet is at its smallest height (`presentationBackgroundInteraction`); scrolling the list
  inside the sheet versus dragging the sheet; selecting a trail re-centres the map and keeps the sheet height; search
  and filters still work; Dynamic Type AX5; VoiceOver; no regressions in Task A behaviors.
- Scored separately: reference comprehension (written requirements against the recording), native integration
  (system sheet and MapKit versus custom machinery, with justification), product quality, reliability, efficiency,
  substantive interventions, compliance with operating rules.

## Pairing and enforcement

- Two fresh copies of the frozen fixture per task; arms differ only in `.claude/skills/apple-product-engineering`
  (v0.2) being present and invoked with `/apple-product-engineering` (or, in a second pair, not invoked, to test
  self-activation).
- Same client build and model; run headless so the configuration is pinned and the time cap is enforced:
  `timeout 3600 claude -p "<brief>" --setting-sources project --strict-mcp-config --mcp-config <same file or none> --model claude-opus-5-5 --output-format stream-json --verbose`.
  `--setting-sources project` keeps the owner's global CLAUDE.md and user skills out of both arms (they were in both
  Folio arms). Provide the project rules (lock prefix, simulator UDID, no erase) in each copy's own `CLAUDE.md`,
  identical in both.
- Xcode MCP: **available to both arms** (owner, 2026-11-26: "Both, I'll approve"). Both arms get the same
  `--mcp-config` with only `xcode-tools` (`xcrun mcpbridge`). Before the first pair, the operator opens the frozen
  fixture through `XcodeOpenWorkspace` from a Claude Code session so the owner can approve in Xcode; check that a
  participant session's call is not refused (approval may be per client) and record what was approved.
- Lock rule for MCP, written identically into both copies' `CLAUDE.md`: Xcode MCP tools that build, test, run,
  render a preview or drive a device (`BuildProject`, `RunAllTests`, `RunSomeTests`, `RunProject`, `RenderPreview`,
  `RunCodeSnippet`, `DeviceInteraction*`) are called only while a holder process owns the heavy lock, e.g.
  `/usr/bin/lockf -k -t 0 /tmp/edraft-checks.lock sh -c 'while [ -e .hold ]; do sleep 2; done' &` after `touch .hold`,
  released with `rm .hold`. Read-only tools (documentation, read, grep, build log, settings, test list, console)
  need no lock. The assessor counts lock violations from the transcripts.
- Random arm order by a logged coin flip; one arm at a time on the shared simulator under `/tmp/edraft-checks.lock`.
- Participants never see this folder, `evaluation/`, earlier submissions or the assessor checks: copies live
  outside this repository and the assessor files stay outside the participant roots.
- Several pairs are needed before any claim; one pair can only reveal failures.

## Next steps (in order)

1. Owner: approve the Xcode MCP decision (both arms or neither) and the builder for the fixture.
2. Build the fixture; freeze its commit; run the baseline under the heavy lock; prove the AX5 defect with a
   screenshot and a failing assessor UI test.
3. Capture and hash the reference recording; write `participant/TASK-A.md`, `participant/TASK-B.md`,
   `assessor/CHECKS.md` and `participant.sha256`, then mark this plan frozen.
4. Run the pairs; score blind.
