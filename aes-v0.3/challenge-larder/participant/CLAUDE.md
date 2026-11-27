# Project rules (identical in both arms)

- Work only inside this folder. Do not read or write anything outside it, except the simulator, Xcode and Xcode's
  own bundled guidance (`xcrun mcpbridge run-agent plugin path` and the folders it names) through the tools below.
- Simulator: use only `iPhone 18 Pro Max` (UDID given in the launch prompt). Never erase, create or delete a
  simulator, and never use another simulator or a physical device. Restore any simulator setting you change.
- Xcode MCP (`xcode-tools`) is available. After every `XcodeOpenWorkspace`, call `XcodeSwitchRunDestination` with
  `iPhone 18 Pro Max`. Pass the UDID to `DeviceInteractionStart*Session`.
- Shared lock: tools that build, test, run, render a preview or drive a device (`BuildProject`, `RunAllTests`,
  `RunSomeTests`, `RunProject`, `RenderPreview`, `RunCodeSnippet`, `DeviceInteraction*`, and any `xcodebuild`,
  `simctl` or `xctrace` command) run only while you hold the shared lock with a holder process:
  `touch .hold; /usr/bin/lockf -k -t 0 /tmp/edraft-checks.lock sh -c 'while [ -e .hold ]; do sleep 2; done' &`
  Release it with `rm .hold` when you finish or stop using such tools for a while. Never put `lockf` in front of a
  command while you hold the lock.
- Any `xcodebuild` takes `-derivedDataPath ./DerivedData`.
- Commit your work to this folder's git repository before you finish. Delete nothing outside this folder.
