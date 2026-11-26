# Folio workspace reveal (trials002/A): report

Date 2026-11-26. Session started 09:43 (layout check); committed 10:29:48. **Elapsed ≈ 47 min.**

## Source
- Commit `dcb54ae` in `…/work/trials002/A` (local only, no remote): `Sources/FolioApp.swift`, `UITests/FolioUITests.swift`.
- Model: the workspace sits underneath; the open collection (its own `NavigationStack`) is the main surface on top.
  Revealing slides the surface right and leaves a 76 pt strip visible. The strip holds the collection's menu, now
  an X (the one close control: no second X, unlike the reference app), and its search field, now a round search
  button. Tapping the strip also closes the workspace; this is a gesture, not a second control.
- Interaction: a horizontal drag anywhere on the workspace or the collection moves the surface 1:1 in both directions
  and settles on release using projected velocity (spring carries the finger's velocity). Reduce Motion: no animation
  (same idiom as the existing `navigate`). Haptic: `.sensoryFeedback(.impact(weight: .light))` only when the state
  actually changes (open or closed), not on a cancelled drag. VoiceOver: escape (two-finger scrub) closes; the closed
  workspace is unmounted, and the covered collection content is hidden while open.
- State: the collection screen stays alive under the reveal, so query, scroll position, selected note, editor text
  selection (`selections`) and path are untouched. Each collection keeps its own memory as before. The app still
  launches on the workspace (public tests rely on it), now with Inbox on the surface beside it.
- Custom engineering, and why the native default wasn't enough:
  1. `RevealPan` (`UIGestureRecognizerRepresentable`, iOS 18+): SwiftUI `DragGesture` read a resting finger on the
     still-moving surface as movement and flung the workspace open (seen in run 1). A UIKit pan measures in window
     space. It runs alongside only scroll views, so a drag over a note row cancels the row's tap like the system back
     swipe. `DragGesture` is kept as the iOS 17 fallback (deployment floor 17.0).
  2. `SurfaceShape`: corner radius ramps in with progress (52 pt). `ConcentricRectangle` is iOS 26-only.
  3. Search: a `ScrollViewReader` scrolls to the top when a search begins. The collection now stays alive, and a
     deep offset over a one-row result left the list blank (public test failed, runs 3–4). A fresh `.id` fixed the
     rendering but dropped keyboard focus (run 5), so it was replaced.
- Liquid Glass: the system toolbar provides the X; the compact search uses `glassEffect(.regular.interactive(), in: .circle)`
  on iOS 26, with `.regularMaterial` below that.

## Test results (`xcodebuild test`, scheme Folio, iPhone 18 Pro Max 7EF1C8CB…, all under `lockf -k -t 0`)
| Run | Result | Notes |
|---|---|---|
| baseline (untouched copy) | 9/9 pass | `baseline-test.log`, `baseline.xcresult` |
| run 1 | 7/10 | tap during settle reopened the workspace (fade-out catcher toggled); hidden field still in AX |
| run 2–4 | 8–9/10 | fixes above, one at a time (`test2…4.log`) |
| run 5 | 8/10 | `.id` search fix lost keyboard focus → replaced |
| **run 6 (final code)** | **10/10 pass** | `test6.log`, `run6.xcresult` (9 public + `testWorkspaceRevealKeepsCollectionState`) |
| recording run | 1/1 pass | reveal test alone, dark appearance, `rec.xcresult` |
Compiler: no warnings in the project's own files. No `FOLIO_AX` audit lines printed in baseline or final logs.

## Recording and resting views
- `reveal-recording-trimmed.mp4` (the full take is `reveal-recording.mov`): the reveal test in dark mode. Open at
  launch, close, short drag snaps back, long drag opens, short drag back stays open, drag closed, menu with search
  keyboard (keyboard goes away), compact search button returns to search with the query kept.
- `matched-resting-views.png`: reference still (annotated) | Folio open | reference closed | Folio closed (dark).
- `before-after.png`: baseline | final for collection, workspace and the Ledger direction (light).
- All per-test screenshots: `views/` (prefixed `baseline--`, `run6--`, `rec--`).

## Requests for human help
1. 09:44: the layout STOP (folder outside ~/Developer). Asked; owner: "Work here".
2. Owner interrupted the first Loupe MCP call: "do not use any mcp". No MCP tools were used after that (no Loupe
   contract or report, no Code Director lock).

## Evidence gaps (not checked)
- Reversing direction mid-drag without lifting: built (progress follows the finger both ways), but XCUI can only
  drag one segment, so it isn't recorded or tested.
- Haptics: the simulator has none; asserted from code only.
- Reduce Motion, Dynamic Type accessibility sizes, VoiceOver escape, landscape, iPad width, the iOS 17 `DragGesture`
  fallback, and the write-failure banner inside the clipped surface: not run.
- Real devices (iPhone 12 Pro / 13 Pro Max): not run.
- Design fidelity is my visual comparison, not a measured match. Strip width 76 pt vs about 70 pt in the reference.
- Workspace rows: a hand-drawn chevron replaces the `NavigationLink` disclosure (rows no longer push). Visually
  matches in `before-after.png`, not pixel-identical.

## Housekeeping
- The installed app was replaced by test builds; its data container was kept (tests use their own
  `FOLIO_TEST_LIBRARY` files; the manual launch used test library `0A000000-…-000000000002.json`).
- Simulator appearance set to dark for the recording, then back to light (checked).
- Nothing was deleted. Two `rm -rf` lines targeted fresh scratch paths that didn't exist yet; one was blocked by a
  safety check and re-run without removal.
- No STATE.md was written: this trial copy has none and isn't in projects.tsv.
