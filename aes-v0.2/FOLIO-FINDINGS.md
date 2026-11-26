# What the Folio trials teach (v0.2 review)

Sources: the published evidence on `main` (both arms' reports, diffs, test JSON, logs, recordings) and, for one
measurement, the raw local recording of Experimental B (`light-recording.mov`, 60 fps, withheld from publication).
Nothing in the trial submissions was changed, rebuilt or re-run.

**Demonstrated** = shown by a recorded artifact or an executed check. **Inferred** = follows from source or
documentation but not observed. **Unresolved** = open; the method to settle it is given.

| # | Finding | Class | Evidence | Lesson now in v0.2 |
|---|---|---|---|---|
| 1 | B's specialist references were never read; only SKILL.md was in context | Demonstrated | `experimental-b/aes/AES-EVIDENCE.md`, activation JSON | SKILL.md now maps problem categories to references and requires reading before deciding; activation re-checked ([ACTIVATION.md](ACTIVATION.md)) |
| 2 | B's closed-form spring estimate equals SwiftUI's `Spring` for the same inputs (max error 5.6e-17) | Demonstrated | [examples/spring-estimate](skills/apple-product-engineering/examples/spring-estimate/) output | The arithmetic was not the problem; what it assumes about the running animation is |
| 3 | Under Reduce Motion B animates `easeOut(0.2)` but still estimates a spring; a grab mid-settle would start up to 91 pt from the drawn surface | Demonstrated in code and arithmetic; on-screen jump inferred (not run with Reduce Motion) | `FolioApp.swift` `settle(revealed:velocity:)`; example output §2 | interaction.md: estimates must match the animation actually used; prefer a readable presentation value |
| 4 | A control tap during a settle restarts B's estimate from rest, while `interpolatingSpring` adds overlapping animations and keeps velocity (SDK 27.2 doc) | Demonstrated (code + SDK text); on-screen size inferred, bounded at 48 pt for one case | example output §3 | interaction.md "Target value and presentation value" |
| 5 | Model tests passed for reversal, flick and interruption; none of the three was executed in the UI | Demonstrated | B `RECORDINGS.md` "not recorded"; A report "Evidence gaps" | interaction.md four-phase table; runtime.md evidence kinds |
| 6 | At release after XCUITest's 0.18 s hold, B's surface moved 12 px in the first 16.7 ms frame; a critically damped settle from rest predicts about 1 px. Tracking before the hold ran at 2–4 px per frame | Demonstrated (raw 60 fps recording, [CSV](evidence/folio-b-open-drag-raw60.csv), rows 32.467–32.483 s) | edge_track.py | runtime.md: measure edges, do not judge by eye |
| 7 | Cause of #6: the pan's reported velocity after a stationary hold is not zero, or the settle starts from a different clock | Unresolved | — | Method: log `velocity(in:)` at `.ended` after a hold, and the settle's start, in a debug run; repeat with a manual drag |
| 8 | At recognition the surface jumped 16 px in one frame, then tracked at 3–4 px per frame | Demonstrated (same CSV, 31.167 s) | edge_track.py | Expected catch-up of the pre-recognition finger travel with 1:1 tracking; noted so it is not misread as a defect |
| 9 | The 30 fps published transcode shows an 11 px/3 px irregularity at the halfway point that the raw 60 fps recording does not | Demonstrated | both CSVs | runtime.md: measure motion on raw captures; transcodes duplicate and drop frames |
| 10 | B removed the reopened-note text assertion from its new UI test after proving the defect pre-existing, and loosened `hasSuffix` to `contains` | Demonstrated | B `VERIFICATION.md`, test diff | SKILL.md hard rule; runtime.md: keep the check as `XCTExpectFailure` |
| 11 | B's final full run had four XCTest "App animations complete notification not received" stalls (~60 s each), two right after reveal interactions; none in the baseline or three earlier full runs. Reported at trial time as unrelated | Demonstrated (log); cause unresolved | B `VERIFICATION.md`, `final.log` | runtime.md stall method. To settle: rerun the two tests alone 5× on the final commit with a recording, `_printChanges()` on the reveal views |
| 12 | `Invalid frame dimension (negative or non-finite)` in every B run: baseline 4, final 5. Not reported at trial time | Demonstrated (counts); source not located | B `VERIFICATION.md` | runtime.md: report warnings with baseline counts; locate computed `.frame` inputs |
| 13 | Control A: a SwiftUI `DragGesture` attached to the moving surface read a resting finger as movement and flung the workspace open | Demonstrated by A's run 1 failure; mechanism inferred (coordinate feedback) | A `REPORT.md` | interaction.md: measure in a stationary space |
| 14 | Changing `.id` to force a redraw dropped keyboard focus (A run 5); B moved the `.id` inward | Demonstrated | A `REPORT.md`, B `AES-EVIDENCE.md` | native.md identity table |
| 15 | "No human interventions" (B) coexisted with deviations: a simulator boot without the lock, `rm -rf` against the deletion rule, work continued past the layout STOP, 68 min 46 s against a 60 min cap | Demonstrated | B `AES-EVIDENCE.md` "Process deviations"; README | runtime.md "Compliance is separate from autonomy"; trial protocol enforces the cap |
| 16 | Both arms' haptic claims rest on code only | Demonstrated | both reports | haptics.md: logged feedback requests are the agent-reachable evidence |
| 17 | Whether a non-animated write during an in-flight SwiftUI animation cancels it (which decides how a grab behaves in B's design) | Unresolved | — | Record a grab mid-settle and measure with edge_track.py |

Neither implementation is made a pattern. The lessons are about evidence and decisions, not about the reveal.
