# Project rules (identical in both arms)

- Work only inside this folder. Do not read or write anything outside it, except the simulator and Xcode through
  the tools below.
- Simulator: use only `iPhone 18 Pro Max` (UDID 7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740). Never erase, create or
  delete a simulator, and never use another simulator or a physical device.
- Xcode MCP (`xcode-tools`) is available. After **every** `XcodeOpenWorkspace`, call `XcodeSwitchRunDestination`
  with `iPhone 18 Pro Max`, because Xcode resets it to another simulator on each open. Pass the UDID above to
  `DeviceInteractionStart*Session`.
- Shared lock: tools that build, test, run, render a preview or drive a device (`BuildProject`, `RunAllTests`,
  `RunSomeTests`, `RunProject`, `RenderPreview`, `RunCodeSnippet`, `DeviceInteraction*`, and any `xcodebuild`,
  `simctl` or `xctrace` command) may run only while you hold the shared lock with a holder process:
  `touch .hold; /usr/bin/lockf -k -t 0 /tmp/edraft-checks.lock sh -c 'while [ -e .hold ]; do sleep 2; done' &`
  Release it with `rm .hold` when you finish or when you stop running such tools for a while. Never put `lockf` in
  front of a command while you hold the lock. Read-only tools (documentation, read, grep, build log, console) need
  no lock.
- Any `xcodebuild` takes `-derivedDataPath ./DerivedData`.
- Delete nothing outside this folder.
