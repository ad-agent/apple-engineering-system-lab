# Product judgment

Use this when the flow is not yet decided, or when asked to make something simpler or better. In a targeted
refinement, preservation.md wins: propose larger changes in the report instead of making them.

## Find the cost the user pays today

Walk the primary journeys in the running app (or the reference) and count:
- screens and taps to reach the task, and to get back;
- decisions the user must make that the app could make (a default, a remembered choice, a detected context);
- moments where the user loses context: a full-screen modal over the thing they were looking at, a lost scroll
  position, a cleared field;
- duplicated controls (two ways to close in one view), confirmation dialogs for undoable actions, alerts that only
  inform.

The worst of these is the opportunity.

## How Apple's apps resolve the same costs

Before inventing, check how a first-party app solves the same problem and which system pieces it uses. Examples:
- Keep context visible: Maps and Find My use a resizable sheet (`presentationDetents`,
  `presentationBackgroundInteraction`) over a live map instead of pushing a new screen.
- Avoid confirmation: Mail and Notes make destructive actions undoable (swipe to delete, Undo) rather than asking.
- Reduce navigation: Photos and Files use the zoom transition from a tapped item so the source stays the spatial
  anchor; Settings search jumps straight to the setting.
- Fewer modes: Reminders and Notes edit in place; there is no separate edit screen.
- Bring actions to the content: context menus with previews, swipe actions, the toolbar's bottom bar on iPhone.
- Use the system's knowledge: Live Text, data detectors, App Intents and Spotlight, Handoff, the share sheet.

Verify the behavior in the actual app on the simulator or a device rather than from memory; behavior changes between
releases.

## Proposing something new

A new interaction is justified when you can state the cost it removes and show that system patterns do not remove
it. Prototype it against the system alternative, run both, and compare the counts above. Keep platform affordances:
the back swipe still goes back, a tap on a row still opens it, VoiceOver still reaches every action. Do not add
custom visuals to look original; differentiation comes from removing work.
