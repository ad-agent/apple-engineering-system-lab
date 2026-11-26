# Existing tools: what was verified, what AES uses

Checked 2026-11-26 on this Mac: Xcode 27.2 (27B52), Claude Code 2.1.311. Nothing was installed and no global
configuration was changed.

## Apple: Xcode MCP (`xcrun mcpbridge`)

| Question | Result | Class |
|---|---|---|
| Is the bridge installed? | `/Applications/Xcode.app/Contents/Developer/usr/bin/mcpbridge`; also `mcp-server` and `lldb-mcp` in the same folder | Verified |
| Does it start without a running Xcode? | Yes: `initialize` returned `xcode-tools` (server version 25464) and launched Xcode in the background | Verified |
| Which tools? | 54 tools, listed in [evidence/xcode-mcp-tools-27.2.json](evidence/xcode-mcp-tools-27.2.json): documentation search, project read/write/grep, schemes, targets, build settings, build and build log, tests (list, all, some), `RenderPreview`, `RunProject`/`StopProject`, `DeviceInteraction*` (start session, install and run, synthesize tap/swipe/type with a screenshot and UI hierarchy back), `GetConsoleOutput`, `InvokeDebuggerCommand`, `RunCodeSnippet`, crash and field-performance reports, localization tools | Verified (inventory) |
| Can an agent call them? | Yes, after the owner approves in Xcode. Approval is per client executable (code identity) and per folder, with a 24 h expiry for folders and unsigned clients; `XcodeOpenWorkspace`/`XcodeNewProject` raise the prompt. Approved 2026-11-26: the check client and `com.anthropic.claude-code` | Verified ([MCP-VERIFIED.md](MCP-VERIFIED.md)) |
| Documentation, project inspection and editing, build diagnostics, preview rendering (with Dynamic Type and appearance overrides), install and run, hierarchy, screenshot, tap, swipe, timed multi-point drag, console | Executed with recorded results | Verified (executed) |
| Debugger (`InvokeDebuggerCommand`) | Fails on this Mac: the attach fails while `RunProject` still reports success; developer mode is disabled | Verified (failure); cause inferred |
| Performance | No MCP tool. `xctrace` Time Profiler and hang triage work on the simulator; Animation Hitches does not ("not supported on this platform") | Verified (executed) |
| Do the tools respect the project's shared lock and simulator rules? | No. They run inside Xcode, outside any `lockf`, and every workspace open set the destination to an eDraft gate simulator. Containment comes from a holder-process window plus a rule to switch the destination after each open | Verified |

Xcode 27.2 also ships Apple-written agent guidance in
`Xcode.app/Contents/PlugIns/IDEIntelligenceChat.framework/Versions/A/Resources/`: `swiftui-specialist` (9 references
incl. animations, data flow, identity), `swiftui-whats-new-27`, `xctrace` (overview, hang triage),
`app-resizability`, `building-document-based-swiftui-applications`, `app-intents-specialist`,
`app-intents-whats-new-27`, `adopt-c-bounds-safety`, `audit-xcode-security-settings`, and 20 documents in
`AdditionalDocumentation/` (Liquid Glass for SwiftUI/UIKit/AppKit/WidgetKit, toolbars, styled text editing,
AttributedString, Swift concurrency and more). `xcrun mcpbridge run-agent skills export --output-dir <dir>` writes them out. On 2026-11-26 it ran into scratch only
(not `~/.claude/skills`), and the export also contains `device-interaction` and `modernize-tests`. AES reads them in place.

## Client-provided

The Claude desktop app's simulator tool offers tap, swipe, multi-point `touch_path` with per-sample timing, text,
hardware keys, appearance and screenshots. `touch_path` can reverse a drag within one touch, which XCUITest cannot.
Its use is subject to the same simulator rules as everything else.

## Third party

| Tool | What it is (read from the repository, not installed) | Decision |
|---|---|---|
| [getsentry/MobileBuildMCP](https://github.com/getsentry/MobileBuildMCP) (MIT, TypeScript, Node 18+) | MCP server and CLI over `xcodebuild`/`simctl`/AXe: build, run, test, logs, LLDB, screenshots, video, UI automation by element reference (tap, touch down/up, drag, swipe, gesture), `erase_sims`, and a bridge to Xcode MCP (`xcode_ide_call_tool`) | Not adopted. It duplicates Xcode MCP and the command line. Cautions if a project uses it: Sentry telemetry on by default; `npx …@latest` pulls unpinned code; UI actions are annotated `readOnlyHint: true`, which can make clients auto-approve them; `erase_sims` is destructive; it does not know local locks |
| [openai/plugins build-ios-apps](https://github.com/openai/plugins/tree/main/plugins/build-ios-apps) | Codex plugin: 9 skills (SwiftUI UI patterns with 28 references, view refactor, performance audit, Liquid Glass, App Intents, ETTrace, memgraph leaks, a simulator debugger flow and a preview browser). Its `.mcp.json` starts `xcodebuildmcp@latest` via `npx` | Not adopted wholesale. Its pattern references overlap Apple's own `swiftui-specialist`; the debugger skill depends on XcodeBuildMCP. Useful ideas (memgraph leak comparison) are noted for a later runtime revision only if a trial shows the need |
| [openai/plugins build-macos-apps](https://github.com/openai/plugins/tree/main/plugins/build-macos-apps) | 11 skills: AppKit interop, build/run/debug, Liquid Glass, packaging and notarization, signing, SwiftPM, SwiftUI patterns, telemetry, test triage, view refactor, window management | Not adopted. No macOS trial exists yet to show a gap these fill |

## What AES contributes

Not tools. AES decides **when** and **why**: which reference to read for which problem, the native-versus-custom
test, the invariants to keep, the four interaction phases and how to observe each, which evidence supports which
claim, and when to stop. Tool use is limited to commands and the two small examples that establish something the
tools do not: the spring-estimate check and per-frame edge measurement.

## Not supported

Physical-device haptics and feel; automated Reduce Motion switching (`simctl ui` has no switch in 27.2); Xcode MCP
under a shell lock; Codex activation of v0.2 (Codex CLI is not installed on this Mac).
