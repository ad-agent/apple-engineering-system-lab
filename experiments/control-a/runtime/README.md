# Control A — runtime evidence

## Recording

[`recordings/reveal-test-dark__redacted.mp4`](recordings/reveal-test-dark__redacted.mp4) comes from the trial
recording of the run `rec` (10:25, dark appearance, final source, `testWorkspaceRevealKeepsCollectionState` only).

- **Original:** 1320×2868, 42.8 s.
- **Published:** a post-trial transcode, H.264 at 660 px wide, 30 fps.
- **Redaction:** frames showing the simulator home screen (0–11.75 s and 36.4 s to the end) are blacked out. The
  timeline is unchanged.

| Video time | Event (log time ≈ video − 7.4…9 s) |
|---|---|
| 11.6 s | App launches with the workspace revealed |
| 15.6 s | Inbox chosen, workspace closes |
| 18.8–22.3 s | Vertical swipe scrolls the collection |
| 24.0–24.7 s | Short drag 0.005→0.20 of the width: the surface follows, then springs back (cancelled open) |
| 26.2–27.6 s | Drag 0.005→0.75: opens (committed) |
| 29.2–29.7 s | Short drag back 0.92→0.75: stays open (cancelled close) |
| 30.3–31.9 s | Drag 0.92→0.10: closes, scroll position kept |
| 33.5–35.5 s | Search field focused, "lantern 3" typed |
| ≈ 35.5 s on | **Not in the video:** menu tap (workspace opens, keyboard dismisses), then the compact search button (closes, keyboard and query return). The test passed these steps; see `screenshots/trial-recording-run/rec__…__reveal-open-searching.png`. |

**Not recorded:**
- reversal within one gesture
- interruption during settling
- flick
- haptics
- the native back swipe
- Reduce Motion
- VoiceOver
- iPad
- iOS 17
- light-appearance video

## Screenshots

- `trial-final-source/final__<test>__<attachment>.png`: XCTest attachments, run 6.
- `trial-recording-run/rec__…`: the open, closed and open-while-searching states in dark appearance.
- `trial-baseline/baseline__…`: the same public attachments from the baseline run.
- `trial-composites/before-after__…png`, made during the trial. Pairs, each baseline then final:
  - collection
  - workspace
  - Ledger direction
- `trial-diagnostic-superseded/`: failure sheets from runs 3–4 and a screenshot of the first build. **Superseded
  code**, kept for transparency.
- `post-trial-derived/`, cut after the trial from the trial recording at 10 fps:
  - `intermediate__cancelled-open-drag…`
  - `intermediate__committed-open-drag…`
  - `intermediate__cancelled-close-drag…`: little visible motion
  - `intermediate__committed-close-drag…`
  - `overview__…-1fps.png`

The participant's matched resting-view sheet put the reference stills beside the Folio states. It is withheld
because it contains reference frames. The same Folio states are published individually above.
