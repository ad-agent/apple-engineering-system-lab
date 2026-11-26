# Paired evaluation

Use the same baseline, brief and permissions twice per pair. A is the stock agent. B adds only the tagged skill folder, installed locally. In B explicitly invoke it once with the brief. Record activation. This measures performance when invoked; automatic discovery requires a separate test. Keep this repository and assessment files outside both participants’ workspaces. Copy the skill only into B. Check stock sessions for inherited copies before starting.

Run Codex and Claude Code as separate strata. Pin client and model versions, reasoning settings, budgets, enabled tools, simulator state and dependency cache policy within each pair. Use fresh sessions with no shared conversation or prior output. Alternate AB and BA across pairs. Reset app data and seed the same fixture between runs. Predeclare three pairs per client per task as an exploratory trial. Record every attempt, including timeouts, requested approvals and environment failures. If infrastructure invalidates one arm, retain its record and rerun the entire pair.

## Scoring before revealing arm identities

Shuffle submission identifiers. Give a reviewer the original task, baseline and anonymized builds. Replay the fixed journeys independently. For each row award 0 for failed or absent evidence, 1 for partial fulfillment, 2 for all observations. Record the evidence path, timestamp and reason. Mark criteria inapplicable before trials and compare only like denominators.

| Dimension | Evidence for full credit |
|---|---|
| Requested outcome | Every task-specific end state matches the frozen brief and real output, including cancellation or failure recovery where specified. |
| Preservation | Matched baseline images and replay show the same unaffected controls, focus and workflows. Reopening preserves expected document contents or preferences. |
| Interaction | Intermediate states follow input, reverse and settle without jumps for gesture work. For editor repair, repeated keyboard retry and undo work in the correct document. For layout work, scrolling and applying remain reachable. |
| Accessibility | Relevant task completes at the specified text size, appearance and accessible input. Reduced-motion navigation reaches the same state where motion changes. |

A build failure attributable to the submission, document loss or a newly failing previously passing test is a release blocker. Record the score and blocker independently. Missing hardware leaves tactile quality unverified. Performance claims require matched Instruments or XCTest measurements on the same device and build configuration.

For each trial retain commit/diff, build command, xcresult if produced, screenshots, recordings and logs. Record elapsed minutes, active human interventions and their reasons, retries, and tokens or cost only when reported by the client. Keep raw evidence outside the skill. Use one row per run:

`task | fixture hash | client/model | pair | blind ID | arm (sealed) | skill commit | time/budget | interventions | four scores | blockers | evidence | exclusions`

Unblind only after scoring. Publish paired B-minus-A scores, wins/ties/losses, blocker counts and median intervention and time differences per task and client. Show individual pairs and missing measurements. Treat a benefit limited to Folio, a single client or one successful run as limited evidence. Require replicated improvements on held-out apps without increased release blockers before claiming a transferable benefit. Report mixed results directly.
