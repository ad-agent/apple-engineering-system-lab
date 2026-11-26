# Trial 005: results (one pair)

Status 2026-11-26 17:3x: both arms ran and finished. Transcript, code and `NOTES.md` scoring is below. **Runtime
checks C1–C12 are pending** (they need a lead-held lock window on `iPhone 18 Pro Max`). One pair can show failures and
differences in behaviour. It cannot show that either arm's configuration is better, and nothing here claims that.

The arm folders, transcripts and screenshots stay in `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/`
and are not published: arm-v02 saved frames from the participant copy of the private recording in `work/ref/`.

## Runs

| | arm-control | arm-v02 |
|---|---|---|
| Prompt | `Read OBJECTIVE.md and CLAUDE.md …` | `/apple-product-engineering Read OBJECTIVE.md …` |
| Wall time (local, +01:00) | 17:10:10–17:17:15 | 17:18:07–17:27:02 |
| Duration, turns, tool calls | 423 s, 72, 71 | 533 s, 88, 86 |
| Reported cost (API-equivalent) | 2.20 USD | 2.75 USD |
| 5-hour plan window used (approx.) | ~17 % | ~20 % (22 → 44 % includes the lead's own use) |
| Ended by | itself (`success`) | itself (`success`) |
| Participant commit | `6c5097c` | `7caa43b` |
| Lead end-of-arm commit (in the arm) | `36c91ba` | `4207fed` |

Neither arm used more than 9 of its 60 minutes.

## Deviations and environment notes (same for both arms unless stated)

1. **Launch environment.** Both arms ran from `env -i` with only HOME, USER, LOGNAME, SHELL, PATH, LANG, TMPDIR and
   `TERM=dumb`, so no desktop-session variables reached them. The command was otherwise exactly ARMS.md's.
2. **Usage rule.** ARMS.md says to start an arm only with room for 60 minutes. arm-control used ~17 % of a Pro
   5-hour window in 7 minutes, so no window can hold 60 minutes at that rate. The lead started arm-v02 at 22 % (78 %
   room, about 4× arm-control's use) and would have voided and rerun it if a limit had cut it. None did.
3. **Xcode folder approval was never exercised.** Xcode allowed only the `starter` folder. Neither arm called
   `XcodeOpenWorkspace`; both built with `xcodebuild` and drove the simulator with `simctl` and
   `DeviceInteraction*`, which need no workspace. So there was no prompt and no intervention, and the
   "`XcodeSwitchRunDestination` after every open" rule had nothing to apply to.
4. **Shared Xcode MCP state.** arm-v02's first `DeviceInteractionStartSession` used the ID `Waypoints Walk`, the same
   ID arm-control had used, and Xcode refused it as recently used; arm-v02 retried with another ID (one extra call).
5. **Device-interaction syntax.** The tool's errors say "review … device-interaction skill", a skill bundled with
   Xcode that neither arm had. Both arms guessed the same wrong commands (`help`, `type`, `k`, `s`, `d`, `swipe`).
   arm-control then found `drag` and made four successful drags; arm-v02 never made a drag. Neither typed text
   (`sender keyboard kbd` is the syntax).
6. **Lead end-of-arm commits** (`git add -A`, as ARMS.md says) also added the frozen inputs (reference copy,
   `CLAUDE.md`, `OBJECTIVE.md`, and in arm-v02 the skill) to each arm's local git. Local only. Diffs below exclude them.
7. **Not blind.** The lead launched both arms and knows which is which.
8. Human interventions: **0 in both arms.**

## Rule compliance (from the transcripts)

| Rule | arm-control | arm-v02 |
|---|---|---|
| Lock: every build, `simctl`, `xctrace` and device call inside a `.hold` window | Yes (window calls 13–69, released) | Yes (calls 16–84, released) |
| No `lockf` prefix while holding | Yes | Yes |
| Simulator `iPhone 18 Pro Max` (UDID 7EF1C8CB…) only | Yes | Yes |
| Writes only inside the arm folder | Yes | Yes. It self-reports one `ls` of Xcode's bundled agent-guidance folder (outside the project; nothing read) |
| `XcodeSwitchRunDestination` after each open | n/a (no opens) | n/a (no opens) |
| DerivedData | `./DerivedData` (git-ignored) | `./DerivedData` (git-ignored) |

## Knowledge consumption (arm-v02 only)

The leading `/apple-product-engineering` expanded `SKILL.md` into the prompt (`-p` does not echo it into the
stream, so this is inferred from what followed). The participant then read 5 of the 7 references with `cat`:
`reference-analysis.md`, `native.md`, `runtime.md`, `product.md`, `interaction.md`. It did not read `haptics.md`
or `preservation.md` or either example. arm-control's skill list did not contain the skill (checked in its `init` event).

## Native integration and architecture (from code)

| | arm-control | arm-v02 |
|---|---|---|
| App Swift files, lines | 5 files, 750 | 5 files, 701 |
| Root sheet | `.sheet` + `presentationDetents` (84 pt peek, medium, large), `presentationBackgroundInteraction` up to medium, `interactiveDismissDisabled` | same pattern (80 pt, medium, large) |
| Map | SwiftUI `Map`, `MapCameraPosition`, `mapControls`, `mapStyle` | same |
| Custom gestures or blur | none | none |
| Glass | one `glassEffect` (control capsule) | one `glassEffect` (control capsule) |
| Controls track the sheet | `onGeometryChange` on the sheet's top edge | `onGeometryChange` on the sheet content's global `minY` |
| Search | `TextField` (not `.searchable`) | `TextField`, with a reason given (`.searchable` needs a navigation bar) |
| Map-style surface | panel that replaces the root sheet | a second sheet stacked over the root sheet |
| Accessibility labels/hints in code | 0 | 7 |
| State | 10 `@State`, 6 `@Binding`, no `@Observable` | 11 `@State`, 10 `@Binding`, 1 `@Environment`, no `@Observable` |
| Look Around | not built (stated as a deliberate omission) | not built (stated) |
| Other files committed | `NOTES.md` | `NOTES.md`, 18 screenshots and a contact sheet under `work/`, `work/snap.sh` |

## Reference comprehension (`NOTES.md` against CHECKS.md O1–O8, I1–I3)

✓ described, ◐ partly, ✗ missing or misclassified.

| | arm-control | arm-v02 |
|---|---|---|
| O1 full-bleed map, root sheet always present | ✓ | ✓ (stated in the build summary) |
| O2 smallest height: floating inset card, search + account | ✓ (no account button) | ✓ (with avatar) |
| O3 further heights (Places, Guides), largest dims the map | ◐ three heights, content not named, no dimming | ◐ Places and Guides named, no dimming |
| O4 search: full height, keyboard, suggestions, X back | ✓ | ✓ |
| O5 controls top-right move with the sheet; Look Around control at left | ◐ left control not noted | ✓ |
| O6 map pans while the sheet rests at a middle height | ✓ ("usable around them", as observed) | ✗ listed as inferred ("not demonstrated by touches") |
| O7 secondary card replaces the root sheet, close, taller state, live map change, restores | ◐ all but the taller state | ◐ no taller state; says the map changes after closing |
| O8 Look Around panel | ✗ named only as omitted | ✗ named only as omitted |
| Observed and inferred kept apart | Yes | Yes, plus an "Unknown" list |
| I1 detents with background interaction | built, not named as an inference | ◐ background interaction named as inferred |
| I2 system glass | described as observed "glass" | described as observed "glass" |
| I3 secondary card keeps the root state | as observed ("earlier height") | as observed ("where it was") |

## Self-reported verification (what each arm says it ran)

| | arm-control | arm-v02 |
|---|---|---|
| Sheet drags | claims collapsed and large drags; transcript shows 4 accepted `drag` commands | none; says so and lists it as not checked |
| Typing a query | not verified (says so) | not verified (says so) |
| Console check | none reported | yes: no SwiftUI runtime warnings; lists system noise |
| Cold-launch blank screen | not reported | reported (5+ s, twice), not profiled |
| Dynamic Type, dark mode, VoiceOver | not checked (says so) | not checked (says so) |

## Runtime checks C1–C12 (assessor)

Pending: to be run in a lead-held lock window on `iPhone 18 Pro Max` against each arm's committed source.
