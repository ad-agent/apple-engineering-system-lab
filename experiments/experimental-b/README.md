# Experimental B — Claude Code with AES v0.1

The participant session ran on 2026-11-26 from 08:02:08 to 09:10:54 CET, a total of 68 min 46 s. The final commit is
`5e5167fbc2b01ac5a34c613b2c4141f17914c2ce` on branch `workspace-reveal`, local only. The baseline is `7764604`.

Most of this folder is the **Experiment B review package**, assembled at 09:28 CET after the trial without changing
the participant repository. It is published file for file:
- every file below matches the package's own [`PACKAGE-MANIFEST.sha256`](PACKAGE-MANIFEST.sha256)
- the package's README is [`PACKAGE-README.md`](PACKAGE-README.md)
- the source matches [`implementation/SOURCE-MANIFEST.sha256`](implementation/SOURCE-MANIFEST.sha256)

See [`../../INTEGRITY.md`](../../INTEGRITY.md).

## Start here

| File | What |
|---|---|
| [`aes/AES-EVIDENCE.md`](aes/AES-EVIDENCE.md) | Configuration, skill activation, references read, decisions mapped to SKILL.md, duration, interventions, difficulties and rejected alternatives, **corrections to the trial-time report**, process deviations |
| [`verification/VERIFICATION.md`](verification/VERIFICATION.md) | Per-run results, warnings, the four quiescence stalls in the final run, limitations |
| [`runtime/RECORDINGS.md`](runtime/RECORDINGS.md) | Scenario index with video times, and the scenarios **not** recorded |
| [`implementation/`](implementation/) | Final source, full diff against the baseline, diffstat, `git ls-tree`, frozen state |
| [`runtime/screenshots/`](runtime/screenshots/) | `trial-final-source/`, `trial-baseline/`, `trial-composites/` (trial) and `post-trial-derived/` (frames cut after the trial) |
| [`activation/activation-evidence.json`](activation/activation-evidence.json) | Sanitized activation and file-read record, produced for this repository with the same script as Control A's |

Summary of the package's own records:
- **Activation:** the SKILL.md body was injected by `/apple-product-engineering` at 08:02:08.
- **Reads:** none of the five specialist references was opened.
- **Interventions and questions:** none.
- **Final run:** 16/16 tests passed.
- **Dark/XXL run:** 2 UI tests.

## Changes made for publication

1. **Recordings.** `runtime/recordings/light-recording.mov` (53 MB) and `darkxl.mov` (66 MB) are replaced by
   `light-recording__redacted.mp4` and `darkxl__redacted.mp4`.
   - These are post-trial transcodes: H.264 at 660 px wide, 30 fps.
   - Frames showing the simulator home screen are blacked out, with the timeline unchanged so that the video times
     in `RECORDINGS.md` still apply:
     - light: 0–15.35 s and 59.65 s to the end
     - dark/XXL: 0–12.15 s, 34.6–35.5 s, 44.2–45.8 s and 93.8 s to the end
   - `RECORDINGS.md` still names the `.mov` files.
2. **Transcript withheld.** `aes/session-transcript-redacted.md` is not published. `AES-EVIDENCE.md` cites line
   numbers in it. It quotes private global instructions and local tool paths. The activation facts it supports are
   in `activation/activation-evidence.json`.
3. **Housekeeping files not copied:** `KEEP.md`, `META`.

Nothing else was changed. The package's statements are its author's: the B session, writing after the trial. They
have not been independently checked beyond the integrity checks in this repository.
