# Director Decision 006 (recorded verbatim)

Provenance: the owner pasted this into the chat of the AES session `resume-appleengineeringsystem-287007` at about
18:20 local on 2026-11-26. That session had stood down, so it relayed the text to the live lead (scheduled session
`next-lead-appleengineeringsystem-287007`), which recorded it here unchanged. **It has not yet been confirmed in the
live lead's own chat.** Until the owner confirms it there, the lead treats it as received, not as a yes to act on.

=== Decision 006, verbatim as the owner pasted it ===

APPLE ENGINEERING SYSTEM — Director Decision 006
Disposition
The Trial 005 development runs are accepted as completed participant submissions.
The comparative evaluation remains incomplete.
AES v0.2 has demonstrated improved specialist reference consumption and integration with native Apple tools. Its effect on final application quality remains unestablished.
Do not modify either frozen participant implementation.
1. Complete independent assessment
Execute the existing runtime checks C1–C12 against both frozen implementations.
Use the approved simulator and established exclusive lock window.
Capture comparable screenshots, interaction recordings, hierarchy evidence, console findings and performance measurements.
Pay particular attention to:

* Persistent sheet behavior.
* Gesture reversal and settling.
* Map interaction at different sheet heights.
* Search entry, cancellation and context restoration.
* Place selection.
* Control positioning.
* Accessibility.
* Cold-launch delays.

Distinguish application defects from tool, simulator and automation limitations.
Do not infer physical tactile or animation quality beyond the available evidence.
Update the published Trial 005 results.
2. Resolve the existing tool-knowledge gap
Both participants struggled to operate Xcode's device-interaction tools despite having access to them.
Investigate the existing Apple-provided device-interaction skill and supporting guidance.
Determine its actual installed location, compatibility and authorized access requirements.
Provide a concise method for existing coding agents to retrieve and apply the relevant guidance when using these tools.
Include verified examples for tapping, text input, scrolling, multi-point dragging, gesture reversal, screenshot capture and hierarchy inspection.
Do not recreate the entire Apple skill.
Prefer consuming the original installed guidance.
Do not create another MCP server, automation framework or tool-routing service.
The objective is operational competence with existing tools.
3. Investigate premature completion
Both participants terminated within nine minutes despite a sixty-minute development budget.
The experimental participant did not exercise the central sheet-drag interaction, could not verify text entry, and reported an unresolved cold-launch delay.
Investigate why the agent considered the assignment complete.
Distinguish:

* Missing tool knowledge.
* Missing product acceptance criteria.
* Inadequate runtime inspection.
* Failure to pursue available diagnostic paths.
* Genuine implementation limitations.
* Legitimate reasons for stopping.

Do not solve this by requiring excessive reporting or arbitrarily increasing development time.
4. Separate autonomous refinement experiment
After the independent assessment, make a new isolated copy of the frozen AES participant implementation.
Preserve the original submission and results.
Provide the agent with the verified Apple device-interaction guidance and a concise instruction to independently inspect, critique and refine the application.
The agent should exercise the actual primary user journeys, identify meaningful defects, investigate their causes and make focused improvements.
It should stop when the essential experience is verified, the authorized budget is exhausted or a genuine blocker prevents continuation.
Do not disclose the assessor's complete findings before this diagnostic session. We want to observe what the agent independently discovers.
Record the refinement results separately from the original Trial 005 experiment.
Do not use this follow-up to claim comparative AES superiority.
5. Publication and privacy
Keep the operator's original recording and extracted reference frames private.
Publish only approved source, sanitized reports, safe synthetic-fixture screenshots and non-sensitive technical evidence.
Do not publish personal geographic information or unrelated local data.
6. Architectural constraints
Do not introduce new artificial agents, orchestration layers or extensive prompt libraries.
Leave developer-security settings unchanged. Retain existing caches and simulator resources unless their removal is separately authorized.
Preserve existing product repositories and the shared verification lock.
Deliverables

* Completed independent Trial 005 assessment.
* Verified Apple device-interaction operating guidance.
* Analysis of premature completion.
* Separate autonomous refinement results.
* Evidence-based recommendations for the next AES revision.

The objective is to develop an agent that independently knows how to experience its own application, recognize its shortcomings and continue engineering until the essential product experience is genuinely complete.

=== end of Decision 006 ===
