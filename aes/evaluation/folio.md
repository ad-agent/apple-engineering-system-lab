# Folio fixture and participant brief

Status: awaiting accepted source revision and reference packet. The assignment supplies neither an object ID nor a recording. Freeze the following before starting either arm. Use an existing acceptance record or ask the owner to identify the accepted build. A branch name, current HEAD or a reconstruction from screenshots is insufficient.

| Fixture field | Required value |
|---|---|
| Accepted source | Read-only source location, full commit ID, acceptance record tying that revision to the pre-redesign build |
| Inputs | Approved reference recording and original change brief, SHA-256 for each, timecodes for the requested interaction |
| Content | Reproducible nonprivate document fixture, checksum and exact launch/navigation steps to the starting state |
| Toolchain | Scheme, test plan, dependency lock revision, Xcode build, OS, destination model, locale, appearance and text size |
| Fingerprint | Baseline screenshots for both endpoints, baseline tests and any pre-existing failures |
| Change | Exact affected surfaces and direction, intended completed and canceled states, explicit scope exclusions from the approved brief |

Prepare a detached clone in a fresh trial directory for every run. Run these commands with an absolute source path and a new TRIAL path. Compare the resulting build and fixture with the acceptance record. If accepted content includes uncommitted changes, obtain an immutable accepted snapshot before running.

```sh
git clone --no-local --no-checkout "$SOURCE" "$TRIAL" &&
git -C "$TRIAL" checkout --detach "$ACCEPTED_SHA" &&
test "$(git -C "$TRIAL" rev-parse HEAD)" = "$ACCEPTED_SHA"
```

## Participant packet

Give each arm only the frozen original brief, reference media, fixture and ordinary project build instructions. Use this wrapper identically in both arms:

“Starting from the supplied Folio build, implement the change in the attached brief. Use the recording to determine how the interaction behaves. Preserve existing editing and document behavior. Deliver the change and evidence of the resulting user experience.”

The assessor retains the baseline captures, rubric, run manifest and arm assignment outside the agent’s accessible project.
