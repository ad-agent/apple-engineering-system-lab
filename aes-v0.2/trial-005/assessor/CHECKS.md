# Trial 005: assessor checks (never given to participants)

Reference analysed by the lead from 1 fps contact sheets of the participant copy (0–44 s). The recording is
private: it shows the operator's neighbourhood, so it is never published and is described here only by behaviour.

## Reference: observed (visible in the recording)

- O1 The map runs full-bleed under the status bar. The root sheet is always present, with no close control at the root.
- O2 Smallest height: a floating, inset, rounded translucent card holding a search field and an account button. The
  map is visible and usable above it.
- O3 Further resting heights: search plus a Places row (about 6 s), then search, Places and a Guides heading. The
  largest height fills the screen with scrolling content (favourites, action rows) and darkens the map (9–10 s).
- O4 Tapping search opens full-height search with the keyboard and category suggestions; X returns to the map (2–4 s).
- O5 Map controls (map style, locate) float at the top-right edge of the sheet and move with it; a Look Around
  control sits at the left.
- O6 The map pans while the sheet rests at a middle height (18–20 s).
- O7 A secondary card (map styles) temporarily replaces the root sheet. It has a close button and a second, taller
  state with toggles, and its choice changes the map live behind it. Closing restores the root sheet (24–44 s).
- O8 Look Around shows a top-anchored panel with Done over the map while the sheet steps aside (15–18 s).

## Reference: inferred (not provable from video)

- I1 System sheet detents with background interaction enabled up through a middle detent.
- I2 System glass materials on the sheet and controls, with no custom blur.
- I3 Secondary cards are presentations that keep the root sheet's state.

## Runtime checks (assessor, on `iPhone 18 Pro Max`, inside a lock window, through Xcode MCP `DeviceInteraction*`)

| # | Check | Method |
|---|---|---|
| C1 | Launches to a full-bleed map with a persistent sheet; dragging down at the smallest height does not dismiss it | screenshot + hierarchy; `mt` drag down |
| C2 | At least three resting heights; drags between each, including a reversal within one touch, settle on a resting height | `mt [x y0] 0.1 [x y1] 0.5 [x y2] 0.4 [x y3] 0.4`, hierarchy frame of the sheet after each |
| C3 | Map pans and zooms while the sheet is at its smallest and middle heights | `t…f` and two-finger `mt` on the map; compare annotation frames |
| C4 | List scrolling inside the sheet versus sheet dragging: at the largest height the list scrolls; at smaller heights a drag resizes the sheet first | swipes on list content |
| C5 | Search: the field expands the sheet and shows the keyboard; typing filters by name; cancel returns to the previous height | `sender keyboard kbd` |
| C6 | Choosing a place re-centres the map on it, selects its annotation, and shows details in the sheet; back or close returns to the list | tap row; tap annotation |
| C7 | Map controls stay visible and are not covered at the small and middle heights, and they track the sheet | hierarchy frames |
| C8 | Dynamic Type AX5: search, rows, details and controls are reachable and unclipped | `simctl ui … content_size` inside the window, restored afterwards |
| C9 | VoiceOver: annotations, rows and controls have meaningful labels | hierarchy labels |
| C10 | Light and dark appearance both correct | `simctl ui … appearance`, restored afterwards |
| C11 | Reliability: 3 launches with no crash; console has no errors or faults from the app | `GetConsoleOutput` oslogSeverity error/fault |
| C12 | Performance: Time Profiler + `xctrace triage --style hangs` across 3 drag cycles; report hangs after launch (hitches are not measurable on the simulator) | `xctrace` inside the window |

## Scored per arm (blind to arm where possible)

Experience (C1–C10), reference comprehension (`NOTES.md` against O1–O8 and I1–I3, observed versus inferred
separated), native integration (system sheet and SwiftUI `Map` versus custom gesture or blur machinery, with
justification), reliability (C11), performance (C12), architectural simplicity (files, lines, state owners),
human interventions (count), and rule compliance from the transcript: lock windows, `XcodeSwitchRunDestination`
after each open, simulator, folder. Experimental arm only: knowledge consumption, meaning the skill was loaded and
the references it read (from the transcript's `Skill` and `Read` calls).
