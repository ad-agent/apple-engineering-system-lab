# Interaction engineering

First check whether a system transition does the job (native.md); for SwiftUI animation APIs read Apple's
`swiftui-specialist` animations reference. Most transitions are ordinary: a push, a sheet,
a zoom, a `withAnimation` state change. Those need no gesture model and no state machine. What follows is for a
continuous, finger-driven interaction that the system does not provide.

## Four phases, four different checks

| Phase | What is true | Typical defect | Check |
|---|---|---|---|
| Tracking | Finger down; the surface follows the finger 1:1 with no animation | Lag, jump at touch-down, fighting a scroll view | Slow drag in a recording: the edge stays under the finger |
| Cancellation | The recognizer ends `.cancelled`/`.failed`, or release decides "go back" | Commits anyway; plays the commit haptic | Short drag and release; incoming call or system gesture |
| Committed settle | Release decided a destination; an animation carries the surface there | Velocity discontinuity at release; wrong destination for a flick | Fast short flick; slow long drag; release exactly at halfway |
| Interruption | A new touch arrives while settling | Surface jumps to where the model thinks it is; the old completion fires and commits the old destination | Grab the surface mid-settle and hold still |

Each needs its own runtime check. A unit test of the model covers none of them on screen.

## Target value and presentation value

With `withAnimation`, the state holds the **target** immediately; what is drawn (the **presentation**) gets there
over time. Code that reads the state during the animation reads the destination, not the position. SwiftUI has no
public API to read the presentation value of an animated state.

So an interruptible surface needs a position you can read:
- **Prefer:** a UIKit-hosted surface animated with `UIViewPropertyAnimator` (iOS 10; `isInterruptible`, pause,
  `fractionComplete`, `continueAnimation(withTimingParameters:durationFactor:)`), or `UIView.animate(_:changes:)`
  with a SwiftUI `Animation` (iOS 18). In both, `view.layer.presentation()` is what is on screen.
- **Or:** advance the value yourself once per frame with `Spring.update(value:velocity:target:deltaTime:)`
  (iOS 17) from a `TimelineView(.animation)` or display link. Then the model value is the presentation value.
- **Avoid:** estimating SwiftUI's presentation with a closed-form spring. [examples/spring-estimate](../examples/spring-estimate/)
  runs that estimate against SwiftUI's own `Spring`. The formula matches `Spring.value` to 1e-16, yet the drawn
  position can differ by tens of points because the formula does not know:
  - which animation is actually running (Experimental B used `easeOut(0.2)` under Reduce Motion but still estimated
    a spring: up to 91 pt off on a 360 pt travel);
  - that `interpolatingSpring` adds overlapping animations and keeps their velocity (SDK 27.2 doc comment), while
    the estimate restarts from rest (up to 48 pt off when a tap reverses a settle 80 ms in);
  - when the animation started: `Date()` in the call is not the first rendered frame (16 pt per 120 Hz frame of
    error early in the settle).

  Whether a non-animated state write during an in-flight SwiftUI animation removes that animation was not
  established; check it in a recording before relying on it.

If grabbing mid-settle is not an acceptance condition, the simplest correct behavior is to let the settle finish and
start the next gesture from the resting value. Say so in the report.

## Coordinates and velocity

- Measure translation in a space that does not move with the surface: the window (`translation(in: nil)`) or the
  stationary parent. Measuring in the moving surface's own space feeds back on itself: a resting finger reads as
  movement. Control A saw exactly this with a SwiftUI `DragGesture` on the moving surface.
- Normalize: progress = clamp(start + signedTranslation / travel, 0, 1), with travel > 0 checked (a zero-width
  first layout pass divides by zero). Sign follows layout direction; mirror it for right-to-left.
- Velocity for `interpolatingSpring(initialVelocity:)` is in units of the **remaining** distance per second:
  `(points per second / travel) / (target - current)`. Passing points per second, or progress per second without
  dividing by the remaining fraction, makes short settles overshoot or crawl.
- Destination on release: project the position (current + velocity × a short carry time, ~0.1–0.2 s) and pick the
  nearer endpoint. Tune on a device; the simulator's mouse drag has no realistic velocity.

## Arbitration with other gestures

Decide who owns a touch before recognition, not after. For a horizontal pan inside vertical scroll views:
`gestureRecognizerShouldBegin` checks the direction (|vx| clearly greater than |vy|, and the direction that can
move the surface); scroll views wait for it to fail with `shouldBeRequiredToFailBy` only where that is needed.
Disable the custom pan while a pushed view is shown so the system back swipe owns the edge. Test diagonal starts,
scrolling, text selection handles, swipe actions on rows and the back swipe, each by hand or with a scripted path.

## Geometry changes and stale completions

- On rotation, window resize or split view, recompute the travel and keep the current progress (or settle to the
  nearer endpoint). Do not keep a cached travel in points.
- Give every settle an identity (a counter). A completion handler acts only if its identity is still current and
  the gesture is not tracking; otherwise it does nothing. Assume a `withAnimation(_:completionCriteria:_:completion:)`
  completion can arrive after a newer gesture or settle has begun.

## Accessibility and Reduce Motion

Every gesture outcome needs a control or an accessibility action (`.accessibilityAction(.escape)` for dismiss, a
labelled button). With Reduce Motion, replace spatial movement with a short crossfade or none; destination and focus
stay the same. Test with the setting on. `xcrun simctl ui` (Xcode 27.2) switches only appearance, content size and
Increase Contrast; set Reduce Motion in the simulator's Settings > Accessibility > Motion, and note that you did.

## Executing reversal and interruption

XCUITest `press(forDuration:thenDragTo:)` draws one straight segment, so it cannot reverse direction in one touch.
Use a multi-point touch path with timing: the Xcode MCP `DeviceInteractionSynthesize` `mt` keyframes (verified
forms in runtime.md; syntax in Apple's `device-interaction` skill), or the client's simulator `touch_path` where it
exists. `XCUICoordinate.press(forDuration:thenDragTo:withVelocity:thenHoldForDuration:)` controls speed and the final
hold of one segment, which is enough for flick and hold-then-release checks. For interruption, start a settle, then touch down within ~100 ms and hold. Record the screen
and measure the surface edge frame by frame (runtime.md); a jump of more than a few points at touch-down is a defect.
