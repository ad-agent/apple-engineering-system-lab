---
name: apple-product-engineering
description: Use when creating, refining, repairing or evaluating a native iOS, iPadOS or macOS app, and whenever a screenshot, recording or existing design is the reference. Covers native-versus-custom decisions, preserving an accepted design, gestures and animation, haptics, runtime verification, and turning a reference into requirements.
---

# Apple product engineering

## Read before you decide

The references below hold the decision methods. Before the first edit that commits to a decision in a category,
read that category's reference with the Read tool. Read only the ones the task touches, and read each one once.
In your first progress note, name the references you read and the category that triggered each one.

| The task involves | Read |
|---|---|
| A screenshot, recording, mock-up or "make it like X" | [reference-analysis.md](references/reference-analysis.md) |
| Choosing between a system component and custom code; navigation, sheets, focus, selection, undo, saving; API availability | [native.md](references/native.md) |
| Changing an app whose current design is accepted (refine, repair, add to) | [preservation.md](references/preservation.md) |
| A drag, swipe, pinch or other continuous gesture; an interruptible or interactive transition; spring tuning | [interaction.md](references/interaction.md) |
| Haptic or other feedback tied to an action | [haptics.md](references/haptics.md) |
| Building, running, testing, recording or profiling; a failing or flaky test; a runtime warning; a hang | [runtime.md](references/runtime.md) |
| A new app or feature whose flow is not yet decided; a request to make something simpler or better | [product.md](references/product.md) |

A bug fix in model code, a string change or a build-setting edit usually needs none of them, or only runtime.md.

## Use what Apple and the client already provide

- Check APIs against the installed SDK, not memory: the Xcode MCP `DocumentationSearch` tool when it is approved,
  or the `.swiftinterface` files under `xcrun --show-sdk-path`.
- Xcode 27 ships Apple-written agent guidance. Read the file that matches the problem before writing that kind of
  code, where it is installed:
  `R="$(xcode-select -p)/../PlugIns/IDEIntelligenceChat.framework/Versions/A/Resources"`. `ls "$R"` lists
  `swiftui-specialist*` (data flow, identity, animation, soft deprecations), `swiftui-whats-new-27*`, `xctrace*`
  (profiling and hang triage), `app-resizability*`, `building-document-based-swiftui-applications*`,
  `app-intents-specialist*` and `AdditionalDocumentation/*.md` (Liquid Glass, toolbars, styled text and more).
  Read them in place; do not copy them.
- Build, test, run and inspect with the tools the session already has: `xcodebuild`, `xcrun simctl`, `xcrun xctrace`,
  the Xcode MCP tools (`xcrun mcpbridge`) and any simulator tool the client provides. runtime.md says which tool
  observes what. Project rules about locks, simulators and user data apply to every one of them, MCP tools included.

## Work order

1. **Classify the task.** Creation, refinement of an accepted design, repair, or evaluation. Write the observable
   acceptance conditions before editing; take them from the brief, not from what is easy to build.
2. **Interpret the reference and the current app** (reference-analysis.md, preservation.md). For a refinement,
   capture the current app's comparable states before the first edit.
3. **Find the owner.** Locate the view, controller, scene or model that owns the behavior. Try the native component
   or container first (native.md). Write custom machinery only for a requirement the native path demonstrably fails;
   record which requirement and what you saw fail.
4. **Implement in small steps** that keep the app buildable.
5. **Run the app and look** (runtime.md). Exercise each acceptance condition in the running app, including the
   intermediate states of any gesture, then critique what you saw as a user would. A green build or test suite is
   necessary, not sufficient.
6. **Refine** only on evidence: a defect you observed, a criterion not met, or a measured problem. Each round names
   the observation, the change and the re-check. Stop when the criteria hold, when the time or usage budget is
   spent, or when a blocker needs the owner. Do not polish past the criteria to look busy.

## Hard rules

- Never weaken, delete or loosen an assertion or acceptance criterion to get green. If a pre-existing defect blocks a
  check, keep the check, mark it as an expected failure with the reason (`XCTExpectFailure`) or leave it failing,
  and report it.
- Report every runtime warning and every test-runner stall you see, even when it also occurs in the baseline. Say
  whether it is new.
- Separate in the report: what you ran and saw (with paths), what tests assert, what you infer from source, and what
  you could not check. Simulator evidence says nothing about tactile feel, device frame pacing or thermals.
- Follow the project's and the operator's rules on locks, simulators, deletion and permissions for every action.
  Doing the task without asking for help is not the same as complying with them; list any deviation.
