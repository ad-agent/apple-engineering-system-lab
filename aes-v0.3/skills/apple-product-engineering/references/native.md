# Native engineering

## Can a system component do it?

1. Write the requirement as observable behavior ("the list keeps its scroll position and search text while the
   panel is open"), not as an implementation ("an overlay with an offset").
2. List the candidates the platform already offers for that behavior: the container's own presentation
   (`NavigationStack`, `NavigationSplitView`, `TabView`, `.sheet` with `presentationDetents` (iOS 16),
   `.inspector`, `.popover`, `.searchable`, `.toolbar`), the zoom transition (`navigationTransition(.zoom)` with
   `matchedTransitionSource`, iOS 18), and the UIKit or AppKit controller that does the same job.
3. Build the smallest version of the best candidate as a throwaway change and run it. Check the requirement, plus
   what the system gives for free: back swipe, Dynamic Type, VoiceOver order, keyboard and pointer, state
   restoration, Liquid Glass styling.
4. Keep it if it meets the requirement. If it fails, write down the exact failure seen ("the sheet covers the
   list's leading edge, the reference keeps 70 pt visible"). That sentence is the licence for custom code, and it
   limits the custom code to that failure: replace the transition, keep the system container, controls and
   toolbar.

Counterexample from the Folio trials: Control A replaced the workspace rows' `NavigationLink` disclosure with a
hand-drawn chevron; Experimental B first gave the toolbar button a custom label view, and a public UI test then
tapped the wrong button. B went back to a standard `Button(_:systemImage:)` that swaps its symbol. Only the reveal
needed custom code; the controls could stay system controls.

## Availability

- Read the deployment target of every affected target: `xcodebuild -showBuildSettings -scheme S` and look for
  `IPHONEOS_DEPLOYMENT_TARGET` or `MACOSX_DEPLOYMENT_TARGET` (or the Xcode MCP `GetTargetBuildSettings`).
- Read the declaration's `@available` in the installed SDK:
  `grep -rn "func navigationTransition" "$(xcrun --sdk iphoneos --show-sdk-path)/System/Library/Frameworks/SwiftUI.framework"`.
  SwiftUI declarations moved partly to `SwiftUICore.framework`; search both.
- Verified on the iOS 27.2 SDK: `UIGestureRecognizerRepresentable`, `navigationTransition`, `matchedTransitionSource`,
  `onScrollGeometryChange`, `onScrollPhaseChange`, `UIView.animate(_: Animation, changes:)` are iOS 18;
  `scrollPosition(id:)`, `sensoryFeedback`, `defaultFocus`, `focusedValue` are iOS 17; `onGeometryChange` and
  `presentationDetents` are iOS 16; `ConcentricRectangle` and `glassEffect` are iOS 26.
- Before using an API you remember from older SDKs, check Apple's `swiftui-specialist` soft-deprecation list and
  `swiftui-whats-new-27` for its current replacement.
- Below the requirement's API floor, decide the fallback explicitly: an older API with the same behavior, a reduced
  behavior that keeps the outcome (a button instead of a drag), or raising the target with the owner's agreement.
  Build for the oldest target, and run the fallback branch at least once if a runtime for it is installed. Say so
  if it is not.

## Identity, focus, selection, undo

SwiftUI views are values; "keep the editor alive" means keep these observable things unchanged across the change:

| Property | How to keep it | How to check it ran |
|---|---|---|
| View identity | Same position in the hierarchy and same `.id`. A conditional (`if`) branch, a changed `.id` or moving the view into another container makes a new identity and discards its `@State`, focus and scroll position. | Put a counter in `@State`, change it, do the transition, confirm the value survived |
| Focus | `@FocusState` bound once; keep the focused view in the hierarchy (hide or cover it rather than removing it) | The keyboard stays up or comes back with the caret where it was |
| Text selection | A selection binding owned above the transition (`TextEditor(text:selection:)` iOS 18, or the UIKit text view's `selectedRange`) | Select a word, transition, type: the word is replaced |
| Scroll position | `scrollPosition(id:)` or the scroll view staying in the hierarchy | Scroll to a known row, transition, the same row is at the same offset |
| Undo | One `UndoManager` per document or editor, from `@Environment(\.undoManager)` of the window, not a new one per view | Type, transition, Undo removes the typing |

Folio evidence: Control A changed a `.id` to make a stale list redraw, and the search field lost keyboard focus
(its run 5). Experimental B moved the `.id` from the `ScrollView` to the inner `LazyVStack` to keep focus.

## Navigation ownership

One owner per navigation state: the `NavigationStack` path, the selected tab, a presented sheet. A custom gesture or
overlay must not keep its own copy of "what is shown". Drive presentation from the owner's state, and let the
system's back swipe keep working: disable your own edge gesture while a pushed view is on screen, or require it to
fail against the system gesture. Check the back swipe by hand after adding any horizontal gesture.

## Documents and saving

Keep transient UI state (reveal progress, selection inside a sheet) out of the saved model. Route edits through the
existing save path and undo manager. When a write fails, keep the draft, show the failure and offer retry; do not
dismiss the editor as if saved. For document apps on SDK 27 load Apple's
`building-document-based-swiftui-applications` skill first (SKILL.md §1).
