# Runtime evaluation

Use the project’s documented scheme, test plan and fixture. Record the source revision, Xcode build, destination OS and device. Use xcodebuild test with a fresh -resultBundlePath for each run when a test scheme exists. Inspect failures and attachments in Xcode. Use existing UI-test screenshots or simctl io with an explicit booted device UDID to capture resting states and a recording of reversal. Review the pixels and playback.

Replay the journey in light and dark appearance, at a large accessibility text size and with Reduce Motion. Check that focus reaches the primary action and returns to a sensible element after dismissal. Record which checks used VoiceOver on hardware. Preserve raw captures and a short index of timestamps and outcomes.

For a reported hitch, profile the same release configuration, device, fixture and gesture with Instruments. Compare repeated traces using the same interval. Separate cold starts from warm repetitions. If measurement is unavailable, describe the observation and leave numerical performance open.

[Apple UI screenshots](https://developer.apple.com/documentation/xcuiautomation/xcuiscreenshot) · [Instruments](https://developer.apple.com/xcode/resources/)
