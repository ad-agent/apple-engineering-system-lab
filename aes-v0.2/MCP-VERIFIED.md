# Xcode MCP: execution check (Decision 005, step B)

Run 2026-11-26, 14:59–15:12 CET, on this Mac: Xcode 27.2 (27B52), `xcrun mcpbridge` → server `xcode-tools` 25464,
54 tools. Fresh project `MCPVerify` (iOS App template, made by `XcodeNewProject`) in
`~/Scratch/AppleEngineeringSystem/2026-11-26-mcp-verify/`. Simulator: `iPhone 18 Pro Max` only.

Every tool below was **called**, not just listed. The calls went through a small stdio JSON-RPC client that keeps one
bridge process open and logs each request and response (`tools/mcpd.py`, `tools/mcpc.py` in the scratch folder). It
was not added to any configuration. A second check used a headless `claude -p` with `--strict-mcp-config`, the same
way the trial arms will run.

Containment: one holder process owned `/tmp/edraft-checks.lock` for the whole window, from 14:59:37 to 15:12:31.
No command inside the window took `lockf`, so the lock was never nested. Afterwards only `iPhone 18 Pro Max` was
booted and `simctl` still listed three devices.

Evidence: [evidence/mcp-verify-2026-11-26/](evidence/mcp-verify-2026-11-26/) holds `calls-summary.tsv` (all 49 calls,
with time, seconds, ok or error, and the first 200 characters), screenshots and the hang triage. The raw logs stay in
scratch because they name personal devices and local paths; their SHA-256 hashes are in `raw-hashes.txt`.

## Results

| Capability | Call(s) | Result | Class |
|---|---|---|---|
| Approval gate | `XcodeListTemplates` before approval; `XcodeNewProject` | Before approval, every call is refused. `XcodeNewProject` raised the prompt in Xcode; the owner approved and the call returned in 15.6 s | **Pass** |
| SDK documentation | `DocumentationSearch` "presentationBackgroundInteraction sheet detents" (SwiftUI) | 1.0 s; returned the iOS 27.2 SwiftUI presentation-modifier docs with signatures, including `presentationBackgroundInteraction`, `presentationDetents(_:selection:)` and the new `presentationPlacement` and `presentationBreakthroughEffect` | **Pass**. Ranking is uneven: from the `claude` client, "presentationDetents selection" ranked an AVFoundation article first. Use framework filters and API-shaped queries |
| Project inspection | `XcodeListWorkspaces`, `XcodeOpenWorkspace`, `XcodeCloseWorkspace`, `XcodeLS` (recursive), `XcodeRead`, `XcodeGrep`, `XcodeListRunDestinations` | All return in under 0.1 s with structured JSON. Paths are relative to the project navigator, for example `MCPVerify/MCPVerify/ContentView.swift` | **Pass** |
| Project editing | `XcodeUpdate` (string replace), `XcodeWrite` (whole file) | Applied and reported byte counts | **Pass** |
| Build diagnostics | `BuildProject` with an undefined identifier, then `GetBuildLog` severity error | Build failed in 8.2 s, with the error at `ContentView.swift:16` "Cannot find 'undefinedGreeting' in scope" in structured `errors`. `GetBuildLog` returned the same issue with the build task. A clean rebuild took 3.2 s | **Pass** |
| Preview rendering | `RenderPreview` default; again with `previewVariantOverrides` {Dynamic Type: AX 5, Color Scheme: Dark} | PNG snapshots ([default](evidence/mcp-verify-2026-11-26/renderpreview-default.png), [AX5 dark](evidence/mcp-verify-2026-11-26/renderpreview-ax5-dark.png)). First render 105.5 s (cold), second 1.4 s. Overrides offered: color scheme, contrast, control borders, 12 Dynamic Type sizes, orientation, static or interactive | **Pass**, with a limitation (see 3 below) |
| Run on simulator | `DeviceInteractionStartWorkspaceSession` (device given by UDID), `DeviceInteractionInstallAndRun` | Session in 4.7 s; build, install and launch in 49.7 s | **Pass** |
| UI hierarchy and screenshot | `DeviceInteractionSynthesize` with no command, or `w 0.5`, plus `activationBundleId` | Returns paths to a screenshot, a thumbnail, a text hierarchy (element type, frame, identifier, label, hitPoint) and a log. Without `activationBundleId` it captured SpringBoard | **Pass** |
| Tap | `t 220 194 w 0.3 t 220 194` on the `tapButton` hitPoint | The hierarchy's `tapCount` label went from "Taps: 0" to "Taps: 2" ([screenshot](evidence/mcp-verify-2026-11-26/di-after-tap.png)) | **Pass** |
| Swipe / scroll | `t 220 800 f 220 250 0.3` | The list scrolled; Row 17 was at the top afterwards ([screenshot](evidence/mcp-verify-2026-11-26/di-after-swipe.png)) | **Pass** |
| Timed multi-point drag with reversal | `mt [220 300] 0.1 [220 700] 0.6 [220 500] 0.4 [220 900] 0.5` | Ran as one touch; the list scrolled back to Row 3. This is the gesture sheet-detent checks need (hold, move, reverse, release) | **Pass** |
| Console | `GetConsoleOutput` pattern `MCPVERIFY`, with metadata | Returned both `Logger` (os_log, with subsystem, category and pid) and `print` (stdio) lines from the taps, tied to the launch session | **Pass** |
| Debugger | `RunProject` `attachDebugger: true` (twice), then `InvokeDebuggerCommand` "process status", "breakpoint set …" | `RunProject` said "launched successfully", but every debugger command returned "No active debug session". The launch log has "Could not attach to pid … LLDB provided no error string", and the process was gone. Plain `lldb` attach found no process either. On this Mac `DevToolsSecurity -status` says developer mode is **disabled**, the likely cause (not proven) | **Fail on this Mac** |
| Performance: Animation Hitches | `xctrace record --template 'Animation Hitches' --device <iPhone 18 Pro Max> --attach <pid>` | "Hitches is not supported on this platform." The simulator cannot measure hitches | **Limitation** (needs a physical device) |
| Performance: Time Profiler + hangs | `xctrace record --template 'Time Profiler' … --attach <pid> --time-limit 12s` while MCP drove scrolls; `xctrace triage --style hangs`; `xctrace toc`/`show` | Recorded 13.7 s; triage found one 871 ms hang at 0.97 s, which lines up with the attach and the activation; app CPU averaged 6.5 % | **Pass** (simulator CPU timing is not device timing) |
| Second client (`claude -p`) | `--strict-mcp-config` with only `xcode-tools`; `XcodeListWorkspaces`, `DocumentationSearch` | Refused until that client called `XcodeOpenWorkspace` and the owner approved it in Xcode. After that, all calls succeeded | **Pass**, with approval per client (see 1 below) |

Not exercised: `RunAllTests`/`RunSomeTests` (the template has no test target), `RunCodeSnippet`, the crash and
field-performance tools (they need App Store Connect data), localization and string-catalog tools, entitlements and
build-setting writers. None of these is needed by Trial 005.

## What the trial must handle (limitations found)

1. **Approval is per client executable, then per folder.** `xcrun mcp-server status` lists permitted agents by code
   identity: the unsigned Python (with a hash, 24 h expiry) and `signed Q6L2SF6YDW com.anthropic.claude-code`. Folders
   are listed separately (24 h expiry). A new client or a new folder raises a new prompt in Xcode. The owner can
   also allow a parent folder ahead of time with `sudo xcrun mcp-server allow-folder` ("a folder and its
   subfolders"), which needs their password. Approval is not by session, so both arms run the same `claude` binary
   under the same approval.
2. **The run destination does not stay put.** Each `XcodeOpenWorkspace` set the destination to
   `eDraft gate iPad Pro 13 iOS 27`, a simulator reserved for eDraft (R10). The switch to `iPhone 18 Pro Max` was
   lost when the workspace was reopened. The real-device iPad and "My Mac (Designed for iPad)" were also eligible.
   Nothing in MCP enforces the simulator rule: the project rules must require `XcodeSwitchRunDestination` (or a UDID
   in `DeviceInteractionStart*Session`) after every open, and the assessor checks for it in transcripts.
3. **Preview rendering uses Xcode's own preview device.** The first `RenderPreview` created an "iPhone 18 Pro Max"
   clone in `~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/`, which `simctl list` does not show,
   and left a preview host process running. Under R10 this counts as an extra simulator that Xcode manages.
4. **DerivedData.** The first `XcodeOpenWorkspace` indexed into the default `~/Library/Developer/Xcode/DerivedData`
   (60 MB, including an index-built `MCPVerify.app`) before a workspace setting could redirect it. Later builds used
   the scratch location from `project.xcworkspace/xcuserdata/<user>.xcuserdatad/WorkspaceSettings.xcsettings`
   (`DerivedDataLocationStyle` = `AbsolutePath`). For trials, write that file into each copy **before** the first
   open.
5. **The lock is advisory.** MCP builds, runs, previews and device sessions happen inside Xcode, so `lockf` cannot
   enclose them. The holder-process window is the containment, and it relies on participants following the rule.
6. **Device sessions are expensive and stateful.** A session without a workspace reported `applicationState`
   "NotRun" for an app that was running and responding. The tool output tells the main agent to delegate
   interactions to a subagent with the Xcode `device-interaction` skill. That is advice about context size, not a
   requirement: direct calls worked.
7. **Debugging** is unavailable here until developer mode is enabled (`sudo DevToolsSecurity -enable`, the owner's
   decision). `RunProject` reports success even when the attach fails, so check `process status` before relying on it.
8. **Hitch measurement** needs a physical device. On the simulator, use Time Profiler plus hang triage, and frame
   analysis of screen recordings (the AES `edge-track` example).

## Xcode-provided skills

`xcrun mcpbridge run-agent skills export --output-dir <scratch>` wrote 11 Apple skills into scratch, not
`~/.claude/skills`: device-interaction, xctrace, swiftui-specialist, swiftui-whats-new-27, app-resizability,
app-intents-specialist, app-intents-whats-new-27, building-document-based-swiftui-applications, adopt-c-bounds-safety,
audit-xcode-security-settings, modernize-tests. `device-interaction` documents the `DeviceInteractionSynthesize`
command syntax (`t`, `d`, `f`, `drag`, `mt`, `b h`, `sender keyboard kbd`, `orientation`). Without it, an agent has
only the schema's one example, `t 100 200`.
