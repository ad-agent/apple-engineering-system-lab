# Using Xcode's own device-interaction guidance

Director Decision 006, step 2. Checked on 2026-11-26 with Xcode 27.2 (build 27B52), macOS 27.2.1, Claude Code 2.1.311
and the `iPhone 18 Pro Max` simulator (iOS 27). This page tells an agent where Apple's guidance is and how to load
it, and lists the commands that were run and what they did. It does not copy the guidance. Read the original.

## Where the guidance lives

Xcode does not ship the guidance as loose files inside `Xcode.app`. A search of the bundle found no `SKILL.md`.
Xcode writes it out on request:

```bash
xcrun mcpbridge run-agent plugin path --plugin-format claude
```

This printed `~/Library/Developer/Xcode/CodingAssistant/ExportedPlugins/27B52/claude`. The folder holds a Claude Code
plugin, `xcode-integration` 1.0.0, with three parts: `.mcp.json`, which defines one server, `xcode` (`xcrun
mcpbridge`); a `skills/` folder with 16 Apple skills; and `.claude-plugin/plugin.json`. The skills include
`device-interaction`, `xctrace`, `swiftui-specialist` and three accessibility specialists (Dynamic Type, VoiceOver,
contrast). The other formats are `codex` and `gemini`. The folder name is Xcode's build number, so the path changes
with every Xcode update. Ask `plugin path` each time instead of writing the path down.

`xcrun mcpbridge run-agent skills export --output-dir <dir>` also writes skills to a folder. On 2026-11-26 it wrote
11 of them, without the accessibility and translation skills. The `device-interaction` text is the same in both
places, apart from the order of its frontmatter.

## Loading it into an existing agent

```bash
claude --plugin-dir "$(xcrun mcpbridge run-agent plugin path --plugin-format claude)"
```

This loads the plugin for that session only and installs nothing. Two short headless runs (Haiku, about $0.008 in
all) checked it. The session listed the plugin, 15 skills named `xcode-integration:<skill>` (the 16th,
`translation-coordinator`, is marked `user-invocable: false`) and the connected `xcode` server. Asked to list its
tools, the agent named `mcp__plugin_xcode-integration_xcode__DeviceInteractionStartSession`, `…StartWorkspaceSession`,
`…InstallAndRun`, `…Synthesize` and `…EndSession`.

Not working here: `xcrun mcpbridge run-agent claude`, which should start Claude with Xcode's configuration, stopped
with "Could not find 'claude' binary", although the Homebrew `claude` is on `PATH`.

## What access it needs

- Xcode was running in every check, and `mcpbridge` connects to the Xcode that `xcode-select` chooses, or to
  `MCP_XCODE_PID`.
- Workspace tools (`DeviceInteractionStartWorkspaceSession`, `InstallAndRun`, builds) need an open workspace, and
  Xcode asks the user to approve the agent (MCP-VERIFIED.md). A session without a workspace
  (`DeviceInteractionStartSession` with a simulator UDID or name) drove an already installed app, and Xcode showed no
  prompt.
- No `sudo`, and no developer mode for simulator interaction. Developer mode stayed off.

## Three places where the guidance and the tools disagree

- The skill calls the interaction tool `DeviceEventSynthesize`. Xcode 27.2 exposes it as
  `DeviceInteractionSynthesize`.
- The skill is written for a main agent that hands interaction to a subagent, and `DeviceInteractionStartSession`'s
  reply says the agent "MUST spawn a SUBAGENT using the device-interaction skill". Nothing enforces this: every
  example below was called directly by one process. AES adds no agent for it (Decision 006 §6).
- The skill says the tools "complete once animations are done". In Trial 005, one capture taken straight after a tap
  came before the transition ended (RESULTS.md, finding labels). Recapture once, as the skill's retry rule says, or
  add `w 1`.

## Verified examples

Run on 2026-11-26 19:12:53–19:13:50, in one lead-held lock window on `iPhone 18 Pro Max`, against the installed
Waypoints test fixture (bundle `test.aes.Waypoints`), with session ID `AES Step2 Examples`. Every call was
`DeviceInteractionSynthesize` with `activationBundleId` set. Each result below was read by script from the hierarchy
the call returned. The y values are the sheet grabber's centre, in points: 865 is the smallest height, 459 the
middle and 70 the largest.

| Goal | `interactionCommand` | Measured result |
|---|---|---|
| Capture, and launch the app if needed | `""` (empty) while the app was not running | App launched (new PID in the hierarchy); hierarchy and screenshot returned in 10.5 s |
| Tap at an element's `hitPoint` | `t 231.5 893.1` (the search field's `hitPoint`) | Field `Keyboard Focused`; sheet 865 → 70 |
| Type text | `sender keyboard kbd falcon` (must end the command chain) | List filtered from 9 visible rows to 2 |
| Multi-point drag | `mt [220 865] 0.1 [220 865] 0.5 [220 520] 0.4` | Sheet 865 → 459 |
| Reversal within one touch | `mt [220 459] 0.1 [220 459] 0.5 [220 100] 0.4 [220 800] 0.4` | Up past the largest height, then down; settled at 865 |
| Swipe | `t 220 865 f 220 520 0.3` on the grabber | Sheet 865 → 459 |
| Press, hold and move | `drag 220 459 220 120` | Sheet 459 → 70 |
| Scroll a list | `t 220 800 f 220 400 0.3`, then `t 220 300 f 220 700 0.3` | Scroll bar 0 % → 42 % → 0 %; sheet stayed at 70 |
| Two-finger pinch | `mt [190 250, 250 250] 0.1 [190 250, 250 250] 0.5 [100 250, 340 250] 0.3`, then the reverse | Markers on screen 40 → 5 → 40 |
| Screenshot | any call | `screenshotPath` (PNG, 440 × 956, in points) and `thumbnailScreenshotPath` |
| Hierarchy | any call | `hierarchyPath`: a text tree of `type, {{x, y}, {w, h}}`, labels, values, `Keyboard Focused` and `hitPoint` per element. Read it by script |

Every result also carries `logsPath`, which was not examined here.

## Method for an agent checking its own app

1. Load Xcode's plugin as above, then read `xcode-integration:device-interaction` in full. Its "Standard Subagent
   Workflow", "Timing and Retries" and "Judging Success vs Failure" sections are the operating rules.
2. Start a session: `DeviceInteractionStartWorkspaceSession` when Xcode builds and runs the app, or
   `DeviceInteractionStartSession` with the simulator's UDID for an installed app. Give each session its own ID.
3. Capture first with an empty command. Before every action, find the target's `hitPoint` in the hierarchy. After
   every action, compare the new hierarchy with the old one: frames, labels, focus, scroll values, element counts.
   For anything driven by gestures (sheets, maps, scroll views), use `mt` keyframes for drags and reversals, and
   `t … f …` for swipes. Check screenshots only for what the hierarchy cannot show: colour, clipping, overlap.
4. End the session with `DeviceInteractionEndSession`.

## Known limits (labelled in trial-005/RESULTS.md)

- In a session without a workspace, `applicationState` reads `NotRun` while the app is running. Use the PID in the
  hierarchy instead.
- No on-screen keyboard appeared in screenshots or the hierarchy, although typing worked. So "the keyboard is shown"
  could not be verified here.
- The hierarchy can report an image button with its glyph's frame rather than its 44 pt hit area. A map marker's
  accessibility frame does not change when the marker is selected.
- `GetConsoleOutput` needs an open workspace. The simulator cannot measure hitches.
