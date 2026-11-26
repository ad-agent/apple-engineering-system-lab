# AES v0.2 — state

Updated 2026-11-26 15:2x by the AES lead (session on branch claude/aes-v0-2-d005-91383d, pushes to aes-v0.2).

## Top block (read first)

- 2026-11-26 17:3x (lead: scheduled session `resume-appleengineeringsystem-287007`, work tree
  `.claude/worktrees/aes-v0-2-d005-91383d`). **Both Trial 005 arms ran and finished on their own**: arm-control
  17:10–17:17 (arm commits 6c5097c + lead 36c91ba), arm-v02 17:18–17:27 (7caa43b + lead 4207fed). Logs:
  `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/arm-*.jsonl` (+ `.err`, `.start`, `.end`, `.pid`).
  Launched with `env -i` (HOME, USER, LOGNAME, SHELL, PATH, LANG, TMPDIR, TERM=dumb). Neither arm opened a
  workspace, so no Xcode prompt and 0 interventions. Nothing running; no lock held.
- `trial-005/RESULTS.md` holds the transcript, code and NOTES scoring and the deviations. **NEXT: runtime checks
  C1–C12** for both arms in one lead-held lock window on `iPhone 18 Pro Max`: build each arm's committed source
  with `-derivedDataPath` in the trial folder, install, drive with `tools/m` (mcpd.py → `xcrun mcpbridge`;
  command syntax in `2026-11-26-mcp-verify/xcode-skills/device-interaction/SKILL.md`), then fill the last section.
  Never publish anything from the arm folders (arm-v02's `work/ref/` holds frames of the participant copy).
- Hand-over 17:3x: this lead ended at the task boundary (context 55 %, runtime checks need a fresh window).
  No start_session tool here, so the next lead is the one-time scheduled task
  `next-lead-appleengineeringsystem-287007` (fires 18:09 local; keep-awake to 18:54). It works in this same
  work tree. Plan usage at hand-over: 5-hour 47 %, weekly 32 %. Owner questions 2–5 below are still open.

Lead hand-over 2026-11-26 ~16:00 (account tag 287007). Next lead: read this block, `get_usage`, `list_sessions
{"linked": true}` (stand down if a live AES lead exists), then do NEXT below.

- DONE: projects.tsv row (owner yes; codedirector-briefs 50e39bb, local commit only). Decision 005 step A/B:
  MCP-VERIFIED.md, TOOLS.md, README (commit 5a20c66). Trial 005 inputs frozen: trial-005/ARMS.md,
  participant/OBJECTIVE.md, participant/CLAUDE.md, assessor/CHECKS.md (this commit).
- Trial folder: ~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/ (META; starter git 90951d3; arm-control,
  arm-v02; mcp-arm-*.json; manifests; coin-flip.log: control first). Recording: ~/Data/AppleEngineeringSystem/
  trial-005/reference/ (original private, never publish; participant copy 0–44 s, no audio, owner's choice).
- NEXT (owner yes: Decision 005 + "Both, I'll approve"): after the 5-hour reset (16:50 local), run arm-control then
  arm-v02 exactly as trial-005/ARMS.md says, one at a time, outside the session (R9 nohup/setsid + keep-awake), only
  when usage has room for a full 60 minutes. Then score both with assessor/CHECKS.md in a lead lock window, write
  trial-005/RESULTS.md, commit, push. One pair can only reveal failures; make no superiority claim.
- Resume: one-time scheduled task `resume-appleengineeringsystem-287007` fires 2026-11-26 16:53 local (keep-awake
  until 17:38). It starts in the default permission mode, so the owner may need to approve its tools.
- In flight: nothing running. No lock held (windows 14:59:37–15:12:31 and 15:43:57–15:55:14, both released).
- OWNER QUESTIONS: (1) run `sudo xcrun mcp-server allow-folder ~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run`
  before the arms (otherwise approve each arm's prompt; logged as an intervention); (2) trash the stray default
  DerivedData `~/Library/Developer/Xcode/DerivedData/MCPVerify-bdsk…` (60 MB)? (3) Xcode's preview device clone
  (`~/Library/Developer/Xcode/UserData/Previews/Simulator Devices/3566F927…`): keep through Trial 005, then
  delete? (4) developer mode for the MCP debugger: enable it or leave it off for both arms? (5) Trailhead builder.
- Rule slip, reported: a 1-minute-old build check cache (`trial005-run/starter-check-DD`, my own) was removed with
  `rm -rf` instead of `trash` (R7). Nothing else was deleted.
- Never write the operator's address or location anywhere; the recording shows it after 44 s.

## Where things are

- Repository: `~/Developer/AppleEngineeringSystem` (clone of `ad-agent/apple-engineering-system-lab`, public).
  `main` = published v0.1 record, untouched. Branch `aes-v0.2`, work tree `.claude/worktrees/aes-v0.2`.
- The brief's path `/Users/x/Developer/AppleEngineeringSystem` did not exist; it was created by this clone. The original
  v0.1 git repository (tag `v0.1`, no remote) is in `~/Documents/Codex/2026-11-25/apple-product-engineering-mission-deliver-applications-2/AppleEngineeringSystem`
  and was not touched.
- Activation scratch: `~/Scratch/AppleEngineeringSystem/2026-11-26-v02-activation/` (transcripts `t1-interaction.jsonl`,
  `t2-unrelated.jsonl`; not published, they carry local configuration).

## Done

See README.md. Skill v0.2, findings, tool evaluation, activation check, trial-005 plan.

## Next steps (in order) — governed by directives/DECISION-005.md (supersedes the order below where they differ)

A. MCP verification window: one holder process owns `/tmp/edraft-checks.lock` for the window (`touch .hold;
   /usr/bin/lockf -k -t 0 /tmp/edraft-checks.lock sh -c 'while [ -e .hold ]; do sleep 2; done' &`); inside it only
   MCP calls and no `lockf`-prefixed commands (no nesting); `rm .hold` ends it. Simulator: `iPhone 18 Pro Max` only.
B. In a fresh project under ~/Scratch/AppleEngineeringSystem/<date>-mcp-verify/, call `XcodeNewProject` or
   `XcodeOpenWorkspace` (owner approves in Xcode; they said yes), then actually execute: DocumentationSearch,
   XcodeLS/Read/Grep, BuildProject + GetBuildLog (with a deliberate error), RenderPreview, DeviceInteraction*
   (tap, swipe, screenshot + hierarchy) on the allowed simulator, GetConsoleOutput, InvokeDebuggerCommand, and
   `xctrace` for performance. Record pass/fail per tool in aes-v0.2/MCP-VERIFIED.md with evidence paths.
C. Trial 005 = Maps-style reference challenge in a fresh isolated project; wait for the operator's recording; write
   participant objective, frozen inputs, assessor checks; then run both arms with identical config and budget.

1. Owner decisions: (a) DONE 2026-11-26: Xcode MCP for **both** arms, owner approves in Xcode ("Both, I'll
   approve"); trigger the prompt with `XcodeOpenWorkspace` on the frozen fixture (step 2), lock rule in
   `trial-005/PLAN.md`; (b) OPEN: who builds the Trailhead fixture (proposed: Grok from `trial-005/PLAN.md`).
2. Build and freeze the fixture; reproduce the AX5 filter-sheet defect under `/usr/bin/lockf -k /tmp/edraft-checks.lock`.
3. Capture the Maps reference recording; write participant and assessor files; hash; freeze.
4. Run pairs headless with `--setting-sources project` and `timeout 3600`; score blind.
5. Settle Findings 7, 11 and 17 (methods in FOLIO-FINDINGS.md) when the simulator lane is free.
6. Check Codex activation when a Codex CLI is installed.

## Owner questions

- Builder for the Trailhead fixture (step 1b).

## Live yeses

- 2026-11-26: Xcode MCP in both Trial 005 arms; the owner approves the agent in Xcode when prompted.
- Brief (Assignment 004 + supplement): work on branch `aes-v0.2` and publish it after review; never touch `main`,
  eDraft, Code Director, Draft Desk or the Folio submissions.
