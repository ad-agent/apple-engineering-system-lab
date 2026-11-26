# Decision 006: completion report

2026-11-26, AES lead. All five deliverables of [Decision 006](directives/DECISION-006.md) are done and pushed to
`aes-v0.2`. One pair of runs and one refinement run back them: they show causes, not that AES v0.2 or v0.3 makes
better apps, and nothing here claims that.

| Deliverable | Where | Headline |
|---|---|---|
| Independent Trial 005 assessment | [trial-005/RESULTS.md](trial-005/RESULTS.md) (C1–C12; step 1 section) | Both arms pass C1–C4, C6, C7 and C9–C11 with the same system-sheet behaviour. arm-v02's Cancel returns to the wrong sheet height; both are Partial at AX5 with different defects. Every finding is labelled App, Tool, Sim or Auto. No app-specific cold-launch delay in either arm |
| Verified device-interaction guidance | [DEVICE-INTERACTION.md](DEVICE-INTERACTION.md) | Where Xcode installs its own device skill, how an agent loads it, and verified examples for tap, typing, scrolling, multi-point drags, reversal, screenshots and the hierarchy |
| Analysis of premature completion | [trial-005/COMPLETION.md](trial-005/COMPLETION.md) | Both arms stopped when nothing they could drive was failing, and filed what they couldn't drive as "not verified". Neither looked at the clock |
| Separate refinement run | [trial-005/REFINEMENT.md](trial-005/REFINEMENT.md) | With Xcode's guidance loaded, the agent made 8 drags, typed, and fixed two defects of its own in 7.5 of 30 minutes. The assessor's C1–C12 afterwards confirmed one fix (the map no longer moves with the sheet) and found the refined app the same as arm-v02 on C1–C11, including the Cancel height and AX5 row-icon defects |
| Recommendations for v0.3 | [RECOMMENDATIONS.md](RECOMMENDATIONS.md) | Five changes in the owner's priority order: point to Xcode's own guidance; write each primary journey's expected end state from the reference; walk journeys at AX5 and dark in the running app; reword the stop rule so "list what is unverified" is not an exit; define a blocker as something outside authority. None adds time, reporting, tools or skill files |

**Lead's own choices in the last step (logged in STATE.md).** The assessor check of the refined app ran in two lock
windows instead of one: the first window's automation typed wait suffixes as text and attached `xctrace` without
`--device`, so a one-minute second window redid C5's "lake" and C12. The cold-launch and C12 numbers for the refined
app are recorded as not comparable (Mac load, different start conditions).

**Owner's authority, recorded during the run.** At 22:55 the owner pasted a Standing Execution Authority into
another AES session's chat. That session recorded it verbatim as
[directives/AUTHORITY-006.md](directives/AUTHORITY-006.md) (`a3b5c58`). The recommendations follow its five
priorities, and STATE.md lists it as a live yes.

**Incident (reported by that session).** At about 22:57 that session's push, sent with an empty source SHA, deleted
`origin/aes-v0.2` for a few seconds. It restored the branch at once to `49a2d1e`, the tip it had just fetched, and
confirmed the restore with `ls-remote`. It reports that no pull request was affected. Nothing was lost: this lead had
not pushed past `49a2d1e` at that time. At 23:1x the remote branch history was checked unbroken from `fa2503a`
through `49a2d1e`, `a3b5c58` and `0bc4203` to `035fa50`.

**Open.** Owner question 5 (who builds the Trailhead fixture) is unanswered; nothing in Decision 006 depends on it.
Applying the recommendations to the skill is v0.3 work, not done here.

**Private evidence, never published:** the operator's recording and its frames, the run transcripts, and the
assessor's captures under `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/`. Its screenshots show map tiles
of a real area.
