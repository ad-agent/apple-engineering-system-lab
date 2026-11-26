# Design preservation

## Creation or refinement

- **Creation:** there is no accepted design to protect. The reference (if any) and the platform set the bar.
- **Targeted refinement or repair:** the current app is the accepted design. Everything outside the requested
  change is an invariant until evidence shows the request cannot be met without changing it. "It looked cleaner"
  is not that evidence.

When unsure, treat it as a refinement.

## Write down the invariants before editing

| Kind | Examples | How to capture |
|---|---|---|
| Visual | toolbar items and their order, symbols, title style, colors, spacing, row layout, materials | screenshots of named states (below) |
| Behavioral | what each control does, gestures that already exist (back swipe, scroll, swipe actions), keyboard shortcuts, focus order, VoiceOver labels and order | a short script of the journey, existing UI tests |
| Data | what is saved, when, and what survives relaunch; selection and scroll restoration; undo history | existing model tests, the stored file before and after |

Existing public tests encode some invariants. Read them before editing and run them on the untouched baseline: a
test that fails there is a pre-existing defect, not yours to hide (see runtime.md).

## Compare equivalent states

1. Choose a fixture with enough content to scroll and a known document or row identity. Use the app's test fixture
   or launch arguments if it has them; never delete or reset the installed user data to get one.
2. Name the states the change touches and their neighbours: e.g. "collection scrolled to row 40", "search with 3
   results", "editor with selection and keyboard". Capture each on the baseline build.
3. Pin what varies between runs: appearance, Dynamic Type size, locale, device and orientation; set the status bar
   (`xcrun simctl status_bar <udid> override --time 9:41 --batteryState charged --batteryLevel 100`) and clear it
   afterwards (`status_bar <udid> clear`); note keyboard visibility, caret position and blinking, and scroll
   momentum.
4. Capture the same states after the change. Compare them side by side aligned on a landmark that should not
   move (the navigation title, a toolbar item). Any difference outside the requested region is a finding: either
   justify it by the request or remove it.
5. For a new interaction that has no baseline equivalent, mark that state "reference only" and compare it to the
   reference instead.

Folio evidence: Experimental B's before/after pair of the spatial test opened different notes (592 against 582),
so the "match" it reported compared different states. Name the row or document in every capture.

## Changing an accepted control

Adapt the existing control before adding one: a menu button that becomes a close button keeps its position, hit
target, accessibility identifier and VoiceOver order, and changes symbol and label. Verify the identifier still
resolves in UI tests (`app.buttons["id"]`), because tests that use `firstMatch` or index find whichever button
comes first.
