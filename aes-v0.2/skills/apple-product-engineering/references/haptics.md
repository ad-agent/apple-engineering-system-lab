# Haptic engineering

## Which events earn feedback

Feedback marks a moment the user cares about: a state actually committed (opened, closed, saved, deleted), a value
actually changed (a selection step), a boundary actually reached, or a failure. Make a table of the interaction's
events and mark which ones get feedback before writing code. Most continuous movement gets none.

System controls (`Toggle`, `Picker`, `Slider` steps, swipe actions, pull to refresh, the context menu) already play
their own feedback. Do not add a second one on top; check on a device what the unmodified control does first.

## Wiring

- SwiftUI (iOS 17): `.sensoryFeedback(_:trigger:)` plays when the `Equatable` trigger changes. Make the trigger the
  committed event, e.g. a counter incremented when a drag commits a state change, or the committed selection.
  A trigger derived from drag progress, or a Bool that flips back and forth while tracking, fires during tracking.
- `.sensoryFeedback(trigger:_:)` with a closure returns `nil` for changes that should be silent; use it to separate
  success from failure (`.success`, `.error`).
- UIKit: `UIImpactFeedbackGenerator`, `UISelectionFeedbackGenerator`, `UINotificationFeedbackGenerator`; call
  `prepare()` shortly before an expected event (touch-down of a drag that may commit), not continuously.
- One owner per event: if the commit can come from a drag, a button and an accessibility action, play the feedback
  in one place that all three pass through, or decide deliberately that only the drag plays it.

## False confirmation

- A cancelled drag (released short of the threshold, or the recognizer cancelled) plays nothing.
- A save confirmation plays after the write succeeds, not when it is requested. A failed write plays `.error` or
  nothing.
- A threshold crossing that previews a commit plays once per crossing; decide when a reversal re-arms it. If the
  interaction only has endpoint feedback, skip the preview and the latch.

## Evidence

| Claim | Evidence that supports it |
|---|---|
| The app requests feedback at the right events, once each | A log line or `os_signpost` at the request point, read with `GetConsoleOutput` (Xcode MCP) or `log stream --predicate 'subsystem == "…"'` while running the journey, including a cancelled drag and a repeated action |
| The trigger does not fire during tracking | The same log while dragging back and forth without releasing |
| The device plays it | A physical device with system haptics on; the simulator plays nothing |
| It feels right (timing, strength) | A person on a named device model and OS. Not claimable by an agent |

Control A and Experimental B both reported haptics "asserted from code only". The next step up is the logged
request, which an agent can produce without hardware.
