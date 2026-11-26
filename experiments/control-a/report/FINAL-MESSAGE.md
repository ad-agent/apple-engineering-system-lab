# Control A — final report as delivered in the session

Verbatim assistant message, 2026-11-26 10:30:22 CET (09:30:22Z), session c95cf5f2. Unedited.

---

The workspace reveal is in and committed locally as `dcb54ae` (there's no remote, so nothing was pushed). All 10 tests pass: the 9 public ones plus a new reveal test. The untouched copy also passed 9/9 before I started.

**What it does**
- **Layout:** the open collection is now the main surface. It slides right to show the workspace and keeps a 76 pt strip visible.
- **Controls:** in that strip, the collection's menu button turns into an X, which is the only close control. The search field shrinks to a round search button. Tapping the strip also closes the workspace.
- **Motion:** a sideways drag on either side follows your finger both ways, then settles on a spring that keeps your release speed. Reduce Motion turns the animation off.
- **Haptics:** a light haptic fires only when the workspace actually opens or closes, not when a drag snaps back.
- **State kept:** the collection screen stays alive underneath, so search text, scroll position, the selected note and editor state are as you left them.
- **Unchanged:** the app still opens on the workspace (the public tests need that), now with Inbox beside it. Typography, icons, colors and the three visual styles are unchanged.

**Custom code, and why**
- **Drag handling:** I replaced SwiftUI's drag with a UIKit pan hosted in SwiftUI. Taps on the still-moving surface were being read as drags and flung the workspace open; the UIKit pan measures in fixed window coordinates. SwiftUI's drag is kept for iOS 17, since the project still targets 17.
- **Search reset:** a search now scrolls to the top when it starts. Because the collection no longer gets rebuilt, a search typed while scrolled deep showed an empty list, and a public test failed on that.

**Requests for help (2):** the folder STOP check, where you said "Work here", and your "do not use any mcp". After that I used no Loupe or Code Director tools.

**Elapsed time:** about 47 minutes (09:43 to 10:30).

**Not checked:**
- Reversing direction mid-drag works in the code, but the test tools can only drag in one stroke, so it isn't tested or recorded.
- Haptics: the simulator has none.
- Not run: Reduce Motion, large Dynamic Type sizes, VoiceOver's close gesture, landscape, iPad width, the iOS 17 fallback, the save-failure banner, and your real iPhones.
- The match to the reference design is my visual judgement, not a measurement.

Nothing was deleted. The simulator was switched to dark for the recording and set back to light. Your Folio app's data was kept; the tests used their own library files.

Everything is in `~/Scratch/Folio/2026-11-26-workspace-reveal-trial002A/` (marked `DONE` and `KEEP.md` so the weekly cleanup leaves it):
- REPORT.md
- reveal-recording-trimmed.mp4
- matched-resting-views.png
- before-after.png
- test6.log and run6.xcresult (final test run)
