# Evaluation material

| File | What it is |
|---|---|
| [TASK.md](TASK.md) | The brief both arms received, verbatim (SHA-256 `69f69aeb9803a3bfbe6810a876eb73823d00c878df19a46f581872eeb2ef782b`). |
| [protocol.md](protocol.md) | AES v0.1 paired-evaluation protocol: arm setup, blind scoring, the four 0/1/2 dimensions (requested outcome, preservation, interaction, accessibility), release blockers, and what to publish. Copy of `../aes/evaluation/protocol.md`. |
| [folio.md](folio.md) | Fixture requirements and participant packet for Folio. Copy of `../aes/evaluation/folio.md`. |
| [holdouts.md](holdouts.md) | Two held-out transfer tasks; not run. Copy of `../aes/evaluation/holdouts.md`. |
| [operator-record.md](operator-record.md) | Assignment 002 operator record: provenance of the baseline, the operator procedure (step 5 lists the replay journeys; step 6 the scoring), and the pre-trial activation smoke run. |
| [pre-trial-activation-smoke.json](pre-trial-activation-smoke.json) | Selected event fields from that smoke run (the Claude Code smoke failed at login; the Codex smoke injected the skill but the model stream failed). |
| [aes-v0.1-audit.md](aes-v0.1-audit.md) | The assessor's editorial audit of AES v0.1, written before the trials. Hypotheses only. |

## Acceptance criteria

The binding requirements are the sentences of [TASK.md](TASK.md). Scoring follows the four dimensions in
[protocol.md](protocol.md#scoring-before-revealing-arm-identities). Release blockers are scored separately:
- a build failure caused by the submission
- document loss
- a newly failing test that passed before

The replay journeys are in step 5 of [operator-record.md](operator-record.md#operator-procedure).

## Status

**Unscored.** No reviewer has replayed or scored either build. Arm identities are not blinded in this repository. A
blind review needs the two `source/` trees, with the folder names and the skill metadata removed.
