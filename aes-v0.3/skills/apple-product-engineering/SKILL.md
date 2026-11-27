---
name: apple-product-engineering
description: Use when creating, refining, repairing or evaluating a native iOS, iPadOS or macOS app; whenever a screenshot, recording, product description or existing design is the reference; and before driving or inspecting a running app in the simulator with Xcode's device tools (it holds verified corrections to Xcode's device-interaction skill). Selects and applies Apple's own Xcode skills, turns the reference into checkable user journeys, and covers native-versus-custom decisions, preserving an accepted design, gestures, haptics, runtime criticism in the running app, and when the work is finished.
---

# Apple product engineering

The aim is an app an exceptional Apple product team would ship: the intended experience works in the running app,
for every user. Apple's Xcode skills hold the platform and tool knowledge; this skill chooses which to apply and what
to check.

## 1. Load Apple's expertise before the decision it informs

Xcode ships Apple-written skills as a plugin. Find it on the installed Xcode each time; the path contains the Xcode
build number, so never write it down:

```bash
P="$(xcrun mcpbridge run-agent plugin path --plugin-format claude)"; ls "$P/skills"
```

- If your skill list shows `xcode-integration:<name>` (session started with `claude --plugin-dir "$P"`), invoke
  it by that name; otherwise read `$P/skills/<name>/SKILL.md` and the `references/` it points to, in place.
- The device tools (`DeviceInteraction*`) exist only with Xcode's MCP server (that plugin or `xcrun mcpbridge`).
  Without them, use the command-line routes in runtime.md; add no other server or agent.
- Framework notes (Liquid Glass, toolbars, styled text, Foundation Models, StoreKit, MapKit and more) are Markdown in
  `"$(xcode-select -p)/../PlugIns/IDEIntelligenceChat.framework/Versions/A/Resources/AdditionalDocumentation"`.
  The `.packaged` files beside that folder are not readable; the plugin has those skills.

Before the first edit or tool call that commits to a decision in a row below, load that row's Apple skill and AES
reference. Load only the rows the task touches, once each, and name them in your first progress note.

| The task involves | Apple skill (`xcode-integration:`) | AES reference |
|---|---|---|
| A screenshot, recording, product description or "make it like X" | — | [reference-analysis.md](references/reference-analysis.md) |
| A new app or flow, or "make it simpler or better" | — | [product.md](references/product.md) |
| SwiftUI structure, data flow, identity, lists, animation APIs | `swiftui-specialist`; `swiftui-whats-new-27` for SDK 27 APIs | [native.md](references/native.md) |
| System component versus custom code; navigation, sheets, focus, undo, saving; availability | `swiftui-specialist` (soft deprecations); `building-document-based-swiftui-applications` for documents | [native.md](references/native.md) |
| Changing an app whose current design is accepted | — | [preservation.md](references/preservation.md) |
| A drag, swipe, pinch or interruptible transition | `swiftui-specialist` (animations) | [interaction.md](references/interaction.md) |
| Haptic or other feedback tied to an action | — | [haptics.md](references/haptics.md) |
| Driving the running app: tap, type, drag, read the hierarchy | `device-interaction` | [runtime.md](references/runtime.md) |
| Text size, VoiceOver, contrast | `accessibility-dynamic-type-specialist`, `accessibility-voiceover-specialist`, `accessibility-sufficient-contrast-specialist` | [runtime.md](references/runtime.md) |
| Launch time, hangs, hitches, CPU, memory | `xctrace` | [runtime.md](references/runtime.md) |
| Resizable windows, iPad multitasking, multiple windows | `app-resizability` | [native.md](references/native.md) |
| Siri, Shortcuts, Spotlight, widgets' intents | `app-intents-specialist`, `app-intents-whats-new-27` | [product.md](references/product.md) |
| Tests to write or migrate | `modernize-tests` | [runtime.md](references/runtime.md) |
| Localizing strings or String Catalogs | `translation-coordinator` | — |

Check any API you are not sure of against the installed SDK (the Xcode MCP `DocumentationSearch` tool, or the
`.swiftinterface` files under `xcrun --show-sdk-path`), not memory. Where Apple's guidance and the installed tools
disagree, runtime.md lists the verified corrections.

## 2. Work order

1. **Classify the task and its authority.** Creation, refinement of an accepted design, repair, or evaluation.
   Routine engineering choices are yours: take the reasonable default, write the assumption in your notes, continue.
   Only a step outside the project's authority needs the owner: money, keys and credentials, deleting user data,
   security settings, publishing, or the project's own rules. A finished milestone is not a reason to ask.
2. **Understand the intended experience** (reference-analysis.md, product.md). Before implementing, write each
   primary journey as *starting state → user action → expected end state*, with the end state taken from the
   reference or brief, not from what is easy to build. Example: "search opened from the smallest sheet height;
   Cancel; the sheet is back at the smallest height and the map shows all places". Name the usability principle
   each journey serves. These are your essential acceptance conditions; keep them in your work notes.
   For a refinement, also capture the current app's comparable states first (preservation.md).
3. **Find the owner.** Locate the view, controller, scene or model that owns the behaviour. Try the native
   component first (native.md). Write custom machinery only for a requirement the native path demonstrably fails;
   record which requirement and what you saw fail.
4. **Implement in small steps** that keep the app buildable.
5. **Run the app and criticise it** (runtime.md): each primary journey from more than one starting state, its
   observed end state compared with the written one in the hierarchy; then largest text size, dark, VoiceOver
   labels. A tool call that succeeded is not a journey that works; a green build is not a good app.
6. **Refine on evidence.** Each round: observation → cause → change → re-check. When you see a meaningful defect
   inside the authorised scope, fix it; outside the scope, report it.

## 3. When the work is finished

Sort the conditions into three kinds:

- **Essential:** the primary journeys and anything the brief requires. Each needs runtime evidence. An essential
  condition without it is unfinished work, not a line in the report: keep working on it.
- **Polish:** improvements beyond the brief. Do them when they are cheap and clearly better; otherwise list them.
- **Device-only:** feel, haptics, frame pacing and thermals. The simulator cannot show them; name them as unverified
  on a physical device. They do not block completion.

In an evaluation the essential conditions are the brief's primary journeys, each run in the app, plus the
system-settings pass. Before stopping, compare your "not checked" list with the essential conditions: anything
essential on it is your next action, not a report line.

Stop only when one of these is true:
- every essential condition has runtime evidence and nothing you observed is still a meaningful defect;
- a genuine blocker: the tool's own guidance (its Apple skill or `--help`) **and** one other route (for example an
  XCUITest instead of synthesized touches, or `simctl` instead of an MCP tool) have both failed, or the next step
  needs the owner (step 1);
- the time or usage budget is spent. Read the clock (`date`) when you start and again before you stop; "out of
  time" is a reason only when the clock shows it.

Then report what remains unverified and why. Once the essential conditions hold, finish; budget left over is not a
reason to keep going.

## 4. Hard rules

- Never weaken, delete or loosen an assertion or acceptance condition to get green. If a pre-existing defect blocks a
  check, keep the check, mark it as an expected failure with the reason (`XCTExpectFailure`) or leave it failing,
  and report it.
- Report every runtime warning and every test-runner stall you see, even when it also occurs in the baseline. Say
  whether it is new.
- Separate in the report what you ran and saw (with paths), what tests assert, what you infer from source, and what
  you could not check.
- Follow the project's and the operator's rules on locks, simulators, deletion and permissions for every action,
  MCP tools included. Working without help is not the same as complying with them; list any deviation.
