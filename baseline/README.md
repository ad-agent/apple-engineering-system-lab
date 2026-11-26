# Folio baseline (frozen benchmark)

| Item | Value |
|---|---|
| Commit | `7764604840e0be2a1c0ddf1ca4f50c2efe3d89fc` ("Freeze verified Folio participant inputs"), the first commit in both trial repositories |
| Contents | [`source/`](source/): `Sources/`, `Tests/`, `UITests/`, `Folio.xcodeproj` (project, workspace data, shared `Folio` scheme), `TASK.md` |
| Deployment floor | iOS 17.0 (see `source/Folio.xcodeproj/project.pbxproj`) |
| Manifests | [`participant.sha256`](participant.sha256) (every participant input, including the reference media) and [`original-source.sha256`](original-source.sha256) (the historical Swift manifest) |

Both arms started from byte-identical copies of this tree. See [`../INTEGRITY.md`](../INTEGRITY.md).

## Provenance

The assessor's [operator record](../evaluation/operator-record.md) traces the source files to the pre-redesign Folio
review baseline. The three project metadata files come from the pre-reveal review capture. Every input is frozen in
`participant.sha256`.

## Baseline test runs (trial evidence)

Each arm ran the public suite on an untouched copy before making changes:

| Arm | Time (CET) | Result | Evidence |
|---|---|---|---|
| Experimental B | 08:07–08:11 | 9/9 passed | [log](../experiments/experimental-b/verification/baseline.log), [summary](../experiments/experimental-b/verification/baseline.summary.json), [screenshots](../experiments/experimental-b/runtime/screenshots/trial-baseline/) |
| Control A | 09:51:05–09:54:26 | 9/9 passed | [log](../experiments/control-a/verification/baseline-test.log), [summary](../experiments/control-a/verification/baseline.summary.json), [screenshots](../experiments/control-a/runtime/screenshots/trial-baseline/) |

Both baseline runs log the runtime warning `Invalid frame dimension (negative or non-finite)` in four UI tests. It
predates either change.

## Historical screenshots

[`historical-screenshots/`](historical-screenshots/) holds three images the assessor kept from before the trials,
as baseline evidence. They were not produced by either arm.

## Reference media (withheld)

The brief points to `References/`, which holds a screen recording and two annotated stills of another company's app
(the Claude iOS app). They show the account holder's real conversation titles and greeting. They are **not
published**; see [`../PUBLICATION.md`](../PUBLICATION.md). Their identities:

| File | SHA-256 |
|---|---|
| `References/claude example.mov` (35.7 s, 1170×2532) | `9fa5956c91188f2534ff03a2979f324750729207304c18ee0697d90422ef0a81` |
| `References/Screenshot 2026-11-25 at 22.36.03.png` (marks the visible strip) | `bf8fda5a6765ce415efe115656451976deebaea0d0bd8e440fea74dde1bc3468` |
| `References/Screenshot 2026-11-25 at 22.44.32.png` (marks the X and the search button) | `0dc912365930c74caf1cff5e65acc650fdc166d182060ac9cd80949e89caaa4e` |

What they show, in words: the reference app's menu slides the main surface to the right and reveals a navigation
list beneath it. A strip of the main surface stays visible. The strip's top control shows an X, and its bottom
control is a compact round search button. Closing slides the surface back. No tactile timing can be recovered from
these media.
