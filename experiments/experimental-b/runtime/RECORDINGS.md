# Runtime evidence — recordings and screenshots

All runs: iPhone 18 Pro Max simulator (7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740), iOS 27.2 (24B8117), built from the frozen source
(commit 5e5167f; last production source change 08:41:26 CET, before every run below).

## Recordings in this package (trial-time, unedited copies)

| File | Run | Content | Size |
|---|---|---|---|
| recordings/light-recording.mov | 09:07:50–09:09:18 CET, light, text size Large | `testWorkspaceRevealKeepsCollectionState` only | 53 MB, 68.0 s |
| recordings/darkxl.mov | 09:05:38–09:07:38 CET, dark, text size XXL | `testCreateCollectionAndFavorite`, then `testWorkspaceRevealKeepsCollectionState` | 80 MB, 94.4 s |

Retained locally, not copied (paths under `~/Scratch/Folio/2026-11-26-workspace-reveal/after/`):
- `final.mov` (208 MB): the final full-suite run, final source.
- `reveal1–5.mov`, `diag1.mov`, `full3.mov`: earlier runs on **superseded intermediate code**. They are not evidence of the final state.

## Scenario index: light-recording.mov

Video time ≈ XCTest log time + 12.0 s. The offset was calibrated after the trial from frames at two drags, ±0.3 s. Drags are XCUITest press-and-drag: a 0.04 s press, a slow straight drag, then a 0.18 s hold. Positions are fractions of the screen width.

| Scenario | Log t | Video ≈ | Recorded? |
|---|---|---|---|
| Launch with the workspace revealed (X shown, compact search) | 10.08 | 22 s | yes |
| Close by choosing a shelf (Inbox) | 10.08 | 22 s | yes |
| Vertical swipe does not reveal | 13.17 | 25 s | yes |
| **Cancelled open** drag, 0.30→0.45 | 16.83 | 28.8 s | yes (frame strip) |
| **Open** by drag, 0.20→0.90; chevron becomes X mid-drag; search field folds into a circle | 18.93 | 31 s | yes (frame strip) |
| **Cancelled close** drag, 0.92→0.78; X stays; card springs back | 22.14 | 34.1 s | yes (frame strip) |
| **Close by control**; X becomes chevron | 25.40 | 37.4 s | yes (frame strip) |
| Open by drag while typing a search; keyboard dismisses | 30.27 | 42 s | yes |
| Close by choosing Favorites, open by control, close by choosing Inbox | 34.60–38.23 | 46–50 s | yes |
| Open by control; close via the compact search button (keyboard appears) | 40.12–41.95 | 52–54 s | yes |
| Edit a note, return, open, continue the note from "Continue writing" | 45.43–52.95 | 57–65 s | yes |

## Scenarios NOT recorded during the trial

- **Close by a leftward drag that commits.** No test or recording performs one. Only the cancelled close drag and the control and row closes were recorded.
- **Reversal within one gesture** (direction change before release). Covered by the unit test `testVelocityDecidesAShortFlickAndAReversal` only, on the model, not in the UI.
- **Interruption** (grabbing the surface while it settles). Covered by the unit test `testInterruptingASettleContinuesFromThePresentedPosition` only. The UI path was never exercised.
- **Velocity flick** (short fast drag). Unit test only.
- **Haptics.** Not observable in simulator recordings. No device run.
- Native back swipe from a note (tests use the back button), Reduce Motion, the VoiceOver escape action, iPad, landscape, iOS 17 (button-only fallback), and text sizes other than Large and XXL.

## Screenshots

- `screenshots/trial-final-source/`: XCTest attachments exported unchanged from the final-source runs. Naming: `<run>__<test>__<attachment>.png`, with run = `final` (full suite) or `darkxl`. The light-recording run's attachments duplicate the final run's reveal-test shots and are retained locally in `~/Scratch/Folio/2026-11-26-workspace-reveal/after/shots-light-recording-named/`.
  - Closed workspace / populated collection: `*collection-scrolled*`, `final__testWorkspaceInboxWritingAndRelaunch__collection-populated`, `final__testSpatialNavigationAndSearchInLargeCollection__collection-large`
  - Revealed workspace: `*reveal-launch*`, `*__revealed.png`, `*revealed-searching*`, and the public tests' `*__workspace.png` (launch state, now revealed)
  - Editor: `final__testWritingAppearance__editor*.png`, `*note-keyboard*`, `*note-reopened*`, `*continued-note*`
- `screenshots/trial-baseline/`: the same public-test attachments from the baseline run on 7764604 (08:07–08:11 CET).
- `screenshots/trial-composites/`: sheets made during the trial from the attachments and recordings above.
  - `resting-before-after`: top row baseline, bottom row final.
  - `revealed-states`: light, then dark/XXL.
  - `intermediate__cancelled-open-drag` and `intermediate__committed-open-drag`: 5 fps frames from light-recording.mov.
  - `note-edited__baseline-vs-change`
- `screenshots/post-trial-derived/`: **made after the trial ended**, by extracting frames from light-recording.mov with ffmpeg. There was no new runtime capture and the app was not re-run.
  - `intermediate__cancelled-close-drag__…-right-crop`: right 45 % of the screen, top half.
  - `intermediate__close-by-control-x-to-chevron__…`
  - `scan__…` and `no-visible-motion__…`: search windows used to locate the cancelled close. The second shows no motion and is kept only for transparency.

### Known differences in matched resting views

- The launch screen intentionally shows the revealed workspace with the collection strip on the right.
- `testSpatialNavigationAndSearchInLargeCollection` `note` opened **Field entry 592** in the baseline and **Field entry 582** in the final run: after scrolling, the public test reached a different row. This was not investigated during the trial. My trial-time report wrongly said the public-test screenshots matched.
- The `continued-note` editor text shows typing artifacts ("Revisihef.") from XCUITest typing. Comparable artifacts appear in the baseline `note-edited` screenshot.
