# Apple Engineering System — lab record

This repository preserves the **Apple Engineering System (AES) v0.1** skill and the evidence from one paired trial on the
Folio benchmark. It exists so the work can be reviewed, rebuilt and scored independently.

> **Status: unscored.** No independent evaluation has taken place. Nothing here shows that AES improves, or does
> not improve, engineering quality. One pair on one task with one client is not enough to say either way, even
> after scoring (see [evaluation/protocol.md](evaluation/protocol.md)).

## The trial

Both arms got the same frozen Folio baseline, the same brief ([evaluation/TASK.md](evaluation/TASK.md)), the same
simulator and the same client and model. They differ in one way: Experimental B had the AES skill installed in the
project and invoked by slash command, and Control A did not.

| | Control A | Experimental B |
|---|---|---|
| Treatment | ordinary Claude Code | Claude Code + `/apple-product-engineering` (AES v0.1) |
| Status | **finished** | **finished** |
| Final commit | [`dcb54ae0e4eaec8006d40959712dd523dcdb7cc9`](experiments/control-a/) | [`5e5167fbc2b01ac5a34c613b2c4141f17914c2ce`](experiments/experimental-b/) |
| Client / model / effort | Claude Code 2.1.311 · `claude-opus-5-5` · effort `high`, adaptive thinking | same |
| Session | 2026-11-26 09:44:21 → 10:30:22 CET (46 min 01 s) | 2026-11-26 08:02:08 → 09:10:54 CET (68 min 46 s) |
| Questions to the operator | 1 (work despite a local folder warning) | 0 |
| Operator interventions | 1 (rejected an MCP tool call and said "do not use any mcp") | 0 |
| AES skill text in context | none | SKILL.md body (injected by the slash command) |
| AES specialist references read | none | **none** |
| Other skill text in context | a user-level skill named `loupe` (Apple-platform guidance, not AES), self-invoked once | none |
| Tests at the end (trial runs) | 10/10 (9 public + 1 new UI test) | 16/16 (9 public + 1 new UI + 6 new unit) |
| Changed production files | `Sources/FolioApp.swift` | `Sources/FolioApp.swift`, `Sources/WorkspaceReveal.swift` (new), `Sources/Library.swift` |

The session times are measured from transcripts. The ordering was **B first, then A**, run one after the other on the
same Mac and simulator. No coin flip was logged. Both arms are single runs.

## Repository layout

| Path | Contents |
|---|---|
| [`aes/`](aes/) | AES v0.1 exactly as tagged (`v0.1` = `cd73beb8dc8752468d806ca9cad319195bd4af7d`): [SKILL.md](aes/skills/apple-product-engineering/SKILL.md), five [specialist references](aes/skills/apple-product-engineering/references/), the compile-only availability check and the original evaluation notes |
| [`baseline/`](baseline/) | Frozen Folio benchmark at `7764604840e0be2a1c0ddf1ca4f50c2efe3d89fc`: source, tests, Xcode project, manifests, historical screenshots |
| [`experiments/control-a/`](experiments/control-a/) | Control A: final source, diff, reports, runtime evidence, logs, activation record |
| [`experiments/experimental-b/`](experiments/experimental-b/) | Experimental B: final source, diff, reports, runtime evidence, logs, activation record |
| [`evaluation/`](evaluation/) | Brief, protocol, scoring dimensions, fixture notes, operator record, audit of AES v0.1 |
| [`INTEGRITY.md`](INTEGRITY.md) | Source identity checks against the frozen commits and final manifests |
| [`PUBLICATION.md`](PUBLICATION.md) | What was withheld or redacted for publication, and why |

## Where to look first

- **Engineering reports.** Control A: [trial report](experiments/control-a/report/REPORT.md),
  [final message](experiments/control-a/report/FINAL-MESSAGE.md) and [evidence record](experiments/control-a/README.md).
  Experimental B: [evidence record](experiments/experimental-b/aes/AES-EVIDENCE.md) and
  [verification](experiments/experimental-b/verification/VERIFICATION.md).
- **Diffs against the baseline.** [Control A](experiments/control-a/baseline-7764604..dcb54ae.diff) and
  [Experimental B](experiments/experimental-b/implementation/baseline-7764604..5e5167f.diff).
- **Recordings.** [Control A](experiments/control-a/runtime/recordings/) and
  [Experimental B](experiments/experimental-b/runtime/recordings/). Compressed, with home-screen frames blacked out.
- **Screenshots.** [Control A](experiments/control-a/runtime/screenshots/) and
  [Experimental B](experiments/experimental-b/runtime/screenshots/).

## Trial and post-trial evidence

Each experiment folder keeps the two kinds of evidence apart.

- **Trial evidence:** produced by the participant session before its final report. This covers source, logs, XCTest
  attachments and the sheets the participant made.
- **Post-trial:** produced afterwards from the unchanged trial artifacts. This covers JSON exports from the xcresult
  bundles, frame strips cut from trial recordings, compressed and redacted video, and activation summaries.

No app was rebuilt or re-run after either trial, and no submission was changed.

## Known differences from the written protocol

[evaluation/protocol.md](evaluation/protocol.md) describes a fuller design than this single pair. In particular:
- Claude Code only, not Codex.
- A single pair.
- No randomised order.
- The 60-minute cap in the [operator record](evaluation/operator-record.md) was not enforced: B ran for 68 min 46 s.
- Both arms ran under the same user-level Claude Code configuration (global instructions and installed user skills),
  which the protocol does not pin.
- No blind scoring has happened yet.
