# Control A — ordinary Claude Code

**Recorded** means read directly from the session transcript, request metadata, git or files. **Retrospective**
means interpretation written after the trial, during the preparation of this repository. Times are CET (UTC+1).

## Frozen state

| Item | Value |
|---|---|
| Final commit | `dcb54ae0e4eaec8006d40959712dd523dcdb7cc9` ("Reveal the workspace beside the collection surface"), branch `main`, local only |
| Baseline | `7764604840e0be2a1c0ddf1ca4f50c2efe3d89fc` |
| Working tree | clean, equal to HEAD (checked again during packaging; see [`../../INTEGRITY.md`](../../INTEGRITY.md)) |
| Source | [`source/`](source/): `Sources/`, `Tests/`, `UITests/`, `Folio.xcodeproj`, `TASK.md`; `References/` withheld |
| Diff | [`baseline-7764604..dcb54ae.diff`](baseline-7764604..dcb54ae.diff), [`baseline-diffstat.txt`](baseline-diffstat.txt): 2 files changed, +437 −80 |
| Manifest | [`SOURCE-MANIFEST.sha256`](SOURCE-MANIFEST.sha256), generated during packaging from the exported final tree |

## Session and configuration (recorded)

- Session `c95cf5f2-cb44-4b39-a445-e9a85945a58c`, Claude Code 2.1.311, run in a fresh copy of the baseline.
- Model `claude-opus-5-5` on every assistant message.
- Request parameters were identical on every API request: `output_config.effort: "high"`,
  `thinking: {type: adaptive, display: updates}`, `max_tokens: 128000`.
- Permission mode: `default` at the start, then `auto` from 09:46:40 until the end. The switch was made in the
  client by the operator.
- Context: the trial ran in one context window. A compaction summary was precomputed at 10:27:07, but the compaction
  boundary was applied at 10:34:49, when the publication request for this repository arrived, after the trial.
  Experimental B shows the same pattern (summary 09:06:22, boundary 09:20:36).
- Global user instructions (`~/.claude/CLAUDE.md`) and user-level skills were present, as they were for B. Their
  text is private and is not published.

## Skill activation and reference consumption (recorded)

Sanitized record: [`activation/activation-evidence.json`](activation/activation-evidence.json).
- **AES:** no copy of the skill was in the project. No AES file was read, and the AES skill was never invoked.
  The only transcript mentions of AES skill paths fall after the trial, during this packaging.
- **Other skill:** at 09:45:20 the model invoked a user-level skill named `loupe`. Its 4,800-character body was
  injected (SHA-256 `18c4dfd1…5094bf6`). It is general Apple-platform guidance, not AES, and its text is not
  published. At 09:45:26 the model called that skill's MCP tool `mcp__loupe__project`. The operator rejected the call
  before it returned and wrote "do not use any mcp". No MCP tool ran during the trial. Loupe's text stayed in the
  context, so **Control A was not free of all Apple-specific skill guidance.** Reviewers should weigh this confound.
- Files read: TASK.md, both reference stills, `Sources/FolioApp.swift`, `Sources/Library.swift`, and the
  participant's own screenshots and contact sheets. The full list is in the JSON.

## Duration (recorded)

| Phase | Time |
|---|---|
| Session start (layout hook) / first user message | 09:43:49 / 09:44:21 |
| Folder question answered; MCP call rejected | 09:44:44–09:45:52 |
| Reading, SDK interface lookups, baseline 9/9 run | 09:45–09:54 (baseline 09:51:05–09:54:26) |
| Implementation with test runs 1–6 | 09:53:16 first source edit → 10:21:09 last production edit; run 6 10:21:20–10:24:45 |
| Recording run, composites, commit `dcb54ae` (10:29:48), final report | 10:25:11–10:30:22 |
| **Total** | **46 min 01 s** from the first user message to the final report. The trial report's "≈ 47 min" counted from 09:43. |

Time inside `xcodebuild test` runs (xcresult start to finish): 1,474 s (24.6 min) over 8 runs.

## Requests for human help and interventions (recorded)

1. 09:44:44 **Question.** The model asked whether to work in the trial folder, because a local layout hook printed a
   STOP warning (the folder lies outside the account's usual project directory). The operator chose
   "Work here (Recommended)".
2. 09:45:48 **Intervention.** The operator rejected the `mcp__loupe__project` call and wrote "do not use any mcp".
   This changed what the participant could do. It is a substantive intervention.

There were no other user messages before the final report.

## Significant engineering decisions and rejected alternatives

Sources are the transcript and the code comments; the reasons given are those recorded at the time.

1. **Two-layer reveal.** The workspace `NavigationStack` stays underneath. The open collection gets its own
   `NavigationStack(path:)` as the main surface and slides right, leaving a 76 pt strip. The collection screen stays
   mounted, so query, scroll position, selection and editor memory are untouched.
2. **Gesture:** a `UIPanGestureRecognizer` via `UIGestureRecognizerRepresentable` on iOS 18+, measured in window
   coordinates.
   - *Rejected:* SwiftUI `DragGesture`, after run 1. The run-1 failure was first blamed on the drag reading a moving
     view. The transcript later traced the real cause to the tap-catcher toggling state during its fade-out (see 4),
     so this rationale is weaker than the trial report states.
   - `DragGesture` is kept as the iOS 17 fallback, which was never run.
   - The pan runs alongside scroll views only, so a horizontal drag over a row doesn't also open the note.
3. **Settling:** an interpolating spring with the finger's velocity handed off, and a projected end of
   translation + 0.25 × velocity. Reduce Motion turns the animation off, the same way the existing `navigate()` does.
4. **Strip taps close only.** The overlay that covers the open surface's content closes and never toggles. It has an
   identity transition.
   - *Rejected:* a toggling catcher with the default fade. During the fade it still caught taps and reopened the
     workspace (run 1).
5. **Hidden workspace is unmounted** after the close animation completes.
   - *Rejected:* `accessibilityHidden` alone. It did not remove the UIKit-backed `NavigationStack` from the
     accessibility tree (runs 1–2).
6. **Compact search state.** The `TextField` is replaced by a stand-in `Text`, so no focusable field stays hidden.
   Separately, a new round search button, using `glassEffect(.regular.interactive())` on iOS 26 and a
   `.regularMaterial` circle below that, closes the workspace and refocuses search via `.task(id:)`.
   - *Rejected:* refocusing from `onChange`, which was unreliable.
7. **Search shows rows after a deep scroll.** A `ScrollViewReader` scrolls to the top when a search begins.
   - *Rejected:* `.id(memory.query.isEmpty)`. It fixed the blank list but dropped keyboard focus after the first
     character (run 5).
   - Retrospective: because the collection now stays mounted, the public spatial test reached this blank-list state.
     Experimental B's record shows the same blank-list behaviour on the baseline (pre-existing).
8. **Menu control.** A `topBarLeading` button with `line.3.horizontal` / `xmark` and a symbol-replace transition.
   - Retrospective: in the baseline the collection was pushed, so its top-leading control was the system back
     chevron, not a menu. Control A *added* this menu button in place of the back chevron rather than transforming
     an existing control. Whether this meets "transform the existing menu into X" is for the reviewer.
9. **Workspace rows** changed from `NavigationLink` to `Button` with a hand-drawn chevron, because rows now switch the
   surface instead of pushing.

## Known defects and unresolved limitations (retrospective unless marked)

None of these was repaired for publication.

- **Not exercised at runtime:**
  - reversal within one gesture
  - grabbing the surface while it settles
  - a velocity flick
  - haptics (the simulator has none; code only)
  - Reduce Motion
  - VoiceOver (including the escape action)
  - Dynamic Type accessibility sizes
  - landscape and iPad
  - the iOS 17 fallback
  - the system back swipe from a note
  - the write-failure banner inside the clipped surface
  - real devices
- **No unit tests** were added. The interaction is covered by one UI test (`testWorkspaceRevealKeepsCollectionState`).
- **Design changes a reviewer may count as unrequested:**
  - the app now launches with the workspace revealed and Inbox beside it
  - the collection's back chevron is replaced by the new menu button
  - tapping the visible strip also closes, besides the X
  - strip width is 76 pt against roughly 70 pt in the reference
  - the corner radius of 52 pt is a judgment value
- **Runtime warning (recorded):** `Invalid frame dimension (negative or non-finite)` in four UI tests in both the
  baseline and final runs.
- **Installed app data:** the trial report says the app's data container was kept, but no before/after hash of the
  container was taken.

## Corrections to the trial-time report (recorded)

1. **Duration:** 46 min 01 s, not "≈ 47 min".
2. **Test runs:** the report says runs 2–4 passed 8–9/10. The xcresult summaries show run 2 at 7/10, run 3 at 8/10
   and run 4 at 9/10 (see [`verification/`](verification/)).
3. **Recording:** the report says the recording shows the menu tap with the keyboard and the compact search button
   restoring search. It does not.
   - The recorded frames switch to the simulator home screen at about 35.5 s, right after "lantern 3" is typed.
   - The test passed those steps (log `t = 25.39–28.56 s`, plus the `reveal-open-searching` attachment), but they
     are not in the video.
   - The trial's own contact sheet was not checked closely enough to catch this.
4. **Deletions:** the report says "Nothing was deleted. Two `rm -rf` lines…". The transcript shows about a dozen
   `rm -rf` commands, each on a per-run scratch path (`runN.xcresult`, `runN-att`) about to be regenerated, and one
   attempt blocked by a safety check. The local rule is to delete only with `trash`.
5. **Lock:** the report says every native operation was locked. One `xcrun simctl list devices` (09:50:56) ran
   without the lock prefix, just before a lock probe. SDK interface lookups via `xcrun --show-sdk-path` were not
   simulator operations.
6. **Skill exposure:** the report does not mention that the `loupe` skill text entered the context (see above).

## Evidence index

| Path | Kind | What |
|---|---|---|
| [`report/REPORT.md`](report/REPORT.md) | trial | Trial-time engineering report (written 10:30:11), unedited |
| [`report/FINAL-MESSAGE.md`](report/FINAL-MESSAGE.md) | trial | Final message to the operator (10:30:22), verbatim |
| [`verification/`](verification/) | trial logs, post-trial JSON | Build and test logs for every run; JSON summaries exported afterwards from the unchanged xcresult bundles ([index](verification/README.md)) |
| [`runtime/screenshots/trial-final-source/`](runtime/screenshots/trial-final-source/) | trial | XCTest attachments from run 6 (final source, light) |
| [`runtime/screenshots/trial-recording-run/`](runtime/screenshots/trial-recording-run/) | trial | Attachments from the dark-appearance recording run (final source) |
| [`runtime/screenshots/trial-baseline/`](runtime/screenshots/trial-baseline/) | trial | Attachments from the baseline run |
| [`runtime/screenshots/trial-composites/`](runtime/screenshots/trial-composites/) | trial | Baseline vs final sheet made by the participant |
| [`runtime/screenshots/trial-diagnostic-superseded/`](runtime/screenshots/trial-diagnostic-superseded/) | trial | Sheets and screenshots from failing intermediate runs and the first build: **superseded code** |
| [`runtime/screenshots/post-trial-derived/`](runtime/screenshots/post-trial-derived/) | post-trial | Motion frame strips cut from the trial recording |
| [`runtime/recordings/`](runtime/recordings/) | post-trial transcode of trial video | The recording run, compressed, with home-screen frames blacked out ([index](runtime/README.md)) |
| [`activation/activation-evidence.json`](activation/activation-evidence.json) | post-trial | Sanitized activation and file-read record |

Withheld: the reference media; the participant's matched resting-view composite and reference contact sheets
(they include reference frames); the raw `.mov`, the trimmed `.mp4` and one diagnostic sheet (they show the
simulator home screen); the raw xcresult bundles and DerivedData; and the session transcript. See
[`../../PUBLICATION.md`](../../PUBLICATION.md).
