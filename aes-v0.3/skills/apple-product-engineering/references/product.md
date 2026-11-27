# Product judgment

Use this for a new app or flow, or when asked to make something simpler or better. Think as an Apple product team
would: start from the person and the moment they use the app, then let the platform carry as much as it can. In a
targeted refinement, preservation.md wins: outside the authorised scope, propose instead of changing.

## Find the cost the user pays

Walk the primary journeys in the running app or the reference and look through seven lenses. The worst cost found is
the opportunity.

| Lens | Ask | Typical cost |
|---|---|---|
| Interaction continuity | Does the thing the user touched stay the thing that moves, opens or answers? | A jump cut, a new screen where the tapped item could have expanded, a gesture that cannot be reversed mid-way |
| Navigation efficiency | How many taps and screens to the task, and back? | A choice the app could default or remember; a confirmation for an undoable action; an alert that only informs |
| Context preservation | What does the user lose on the way? | A full-screen modal over what they were looking at; a lost scroll position, cleared field or forgotten selection |
| Information hierarchy | Is the primary content and action obvious at a glance? | Everything the same weight; the primary action in a menu; secondary detail before the answer |
| Responsiveness | Does every touch answer at once, and is waiting shown? | A blocked main thread, a spinner with no progress, a launch that shows nothing useful |
| Accessibility | Does it work at the largest text size, with VoiceOver, in dark, with Reduce Motion? | Truncation, fixed-size icons, unlabelled buttons, gesture-only actions |
| Native platform integration | Does it use what the system already knows and does? | Hand-made controls, no share sheet, no Spotlight or Shortcuts, ignoring the keyboard and pointer on iPad |

## How Apple's apps resolve the same costs

Before inventing, check how a first-party app solves the problem and which system pieces it uses:
- Keep context visible: Maps and Find My use a resizable sheet (`presentationDetents`,
  `presentationBackgroundInteraction`) over a live map instead of pushing a new screen.
- Avoid confirmation: Mail and Notes make destructive actions undoable rather than asking.
- Keep the spatial anchor: Photos and Files open an item with the zoom transition from where it was tapped.
- Fewer modes: Reminders and Notes edit in place; there is no separate edit screen.
- Bring actions to the content: context menus with previews, swipe actions, the bottom toolbar on iPhone.
- Use the system's knowledge: Live Text, data detectors, App Intents and Spotlight, Handoff, the share sheet
  (`app-intents-specialist` for intents).

Behaviour changes between releases: check it in the actual app on the simulator, not from memory.

## Deciding what to build

- Every addition names the cost it removes and the lens it belongs to. "It looks more distinctive" is not a cost.
- Prefer removing work over adding features: one fewer screen, one fewer decision, nothing retyped.
- A new interaction is justified when system patterns do not remove the cost. Prototype it against the system
  alternative, run both, compare the counts above.
- Keep platform affordances: the back swipe goes back, a tap on a row opens it, VoiceOver reaches every action,
  Dynamic Type scales everything.
- No decorative customization: custom colours, shapes and animations that solve nothing make the app less native.
- Write the decision and its reason in your notes in one line, and continue; it does not need the owner.
