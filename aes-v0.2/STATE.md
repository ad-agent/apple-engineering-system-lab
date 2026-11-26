# AES v0.2 — state

Updated 2026-11-26 22:2x by the AES lead (session on branch claude/aes-v0-2-d005-91383d, pushes to aes-v0.2).

## Top block (read first)

- **IN FLIGHT 2026-11-26 22:21 — Decision 006 step 4 refinement run** (lead: scheduled run
  `next-lead-appleengineeringsystem-287007`, fired 22:18; the 21:53 lead had stood down). Started 22:21:44,
  `timeout 1800` (cut at 22:51:44), PID 58823 (setsid; keep-awake hold on it). Folder
  `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/refine-v02` (clone of arm-v02 at `7caa43b`, branch
  `refine`, no remote; arm-v02's own frozen inputs copied and checked against `arm-v02.manifest.sha256`: 14/14 OK;
  lead's input commit `db89e30` adds `REFINE.md` and a sanitized `DEVICE-METHOD.md`). Log `../refine-v02.jsonl`,
  `.err`, `.start`, `.end`. Launch = arm-v02's ARMS.md command with `timeout 1800`, prompt `/apple-product-engineering
  Read REFINE.md, DEVICE-METHOD.md and CLAUDE.md …`, plus `--plugin-dir` Xcode's exported plugin (skills only: under
  `--strict-mcp-config` the plugin's own `xcode` server is dropped; checked with a Haiku load check, evidence in
  `~/Scratch/AppleEngineeringSystem/2026-11-26-d006-step4/`). Subagent choice: Agent/Task NOT in `--allowedTools`
  (same tool set as the arm; DEVICE-METHOD.md says to call the device tools directly, as step 2 verified). Heavy lane
  free at start; memory pressure "warn". **When it ends**: check for a leftover `refine-v02/.hold` (trash it), commit
  the agent's result in the folder, then write `trial-005/REFINEMENT.md` (separate from RESULTS.md; no superiority
  claim; the agent's notes, diff summary, what it exercised, by script from the jsonl). If a usage limit cut it:
  "budget exhausted", no rerun without the owner.
  Usage: 5-hour 22 % at 22:18, 32 % at 22:23 (resets **02:50 local**, i.e. 01:50 UTC; earlier entries saying "01:50
  local" were wrong). At this pace the run may use up the window before 22:51 and this lead with it. **No resume is
  armed**: re-arming `resume-appleengineeringsystem-287007` for 02:53 was refused (needs a person's approval; this is
  an unattended run). If this lead goes quiet, the owner can start a fresh AES lead in this work tree after 02:50, or
  approve that task, to do the "When it ends" steps above.
- **HAND-OFF 2026-11-26 22:0x** (lead: scheduled run `resume-appleengineeringsystem-287007`, fired 21:53).
  **Decision 006 step 3 is DONE**: `trial-005/COMPLETION.md` (linked from README; commit named in git log as
  "Decision 006 step 3"). Plan usage 5-hour ~10 % (resets 01:50 local), weekly 40 %; context 55 %. In flight:
  nothing. No lock held, no keep-awake hold, no scheduled task created or changed (an unattended run may not).
  Private evidence: `~/Scratch/AppleEngineeringSystem/2026-11-26-d006-step3/` (timeline script and per-arm
  timelines built from the transcripts; never publish). Headline: neither arm ever looked at the clock; both stopped
  when nothing they could drive by tapping was failing, and filed what they could not drive as "not verified".
  Causes ranked per gap (tool knowledge primary for drag and typing; unused paths: the word `drag`, XCUITest,
  `xcrun mcpbridge --help` → `run-agent skills`; v02 accepted the Cancel defect it was looking at because it had no
  written expected end state; the cold-launch delay was never measured). COMPLETION.md names assessor findings:
  **the step 4 agent must not see it.**
- **OWNER ANSWER 2026-11-26 22:1x, in chat: "30 min now"** (budget question below). So step 4 runs with
  `timeout 1800`, started as soon as the next lead has prepared it, not after a reset. The 5-hour window was at
  20 % at 22:11 (resets 01:50 local); at ~2.4 %/min a 30-minute run needs ~72 %, plus the lead's own use, so it is
  tight: if a usage limit cuts the run, record it as "budget exhausted" and do not rerun without asking. Next lead:
  the one-time task `next-lead-appleengineeringsystem-287007`, re-armed by the stood-down 17:xx lead for ~22:18.
- **NEXT: Decision 006 step 4** (separate autonomous refinement). Owner question first, because it blocks the launch:
  **the budget.** At the Trial 005 rate (~2.4 % of the Pro 5-hour window per minute) a 60-minute run needs ~145 % of
  one window and cannot finish inside it (extra usage is off). Lead's pick, unless the owner says otherwise: start
  right after a 5-hour reset with `timeout 3600`, and record a usage-limit cut as "budget exhausted" for this
  experiment (it is not a scored arm). Alternative: `timeout 1800`, which fits one window. Preparation notes for the
  lead that does it (fresh session, R9):
  1. Copy: `git clone` the arm-v02 folder's repo into a NEW folder inside
     `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/` (Xcode's allow-folder covers it until
     2026-11-27 19:47 local) and check out participant commit `7caa43b`. That commit lacks the frozen inputs the lead
     added later in `4207fed` (`.claude/skills/apple-product-engineering`, `CLAUDE.md`, `OBJECTIVE.md`); copy those
     from the arm's own folder, not from this repo's newer skill. Leave arm-v02 itself untouched.
  2. Guidance: give Xcode's own plugin (`claude --plugin-dir "$(xcrun mcpbridge run-agent plugin path
     --plugin-format claude)"`). Do NOT hand over `DEVICE-INTERACTION.md` as is: its examples carry the assessor's
     fixture measurements and its "Known limits" point to RESULTS.md findings. If a short method is needed, write a
     sanitized one (commands and how to read the hierarchy only).
  3. Xcode's StartSession reply demands a subagent with the device-interaction skill. Decide whether the run's
     `--allowedTools` includes the subagent tool (Xcode's requirement) or not (direct calls work, step 2); Decision
     006 section 6 forbids adding agents of our own, not Xcode's own workflow. Note the choice in the run's record.
  4. Folder rule: say that the tools' own output files and Xcode's bundled guidance may be read (COMPLETION.md,
     implication 5). Keep the instruction concise; it must not mention any assessor finding.
  5. Run outside the session (R9 nohup/setsid + keep-awake), under the shared lock rules of the arm's CLAUDE.md.
     Record results in a new `trial-005/REFINEMENT.md`, separate from RESULTS.md, with no superiority claim.
  Then: recommendations for the next AES revision (inputs: COMPLETION.md's implications). Owner question 5
  (Trailhead builder) is still open. Live yes: Decision 006.
- 2026-11-26 21:5x: the scheduled resume fired at 21:53 as set; no other AES lead was running.

- **2026-11-26 19:5x — RESUME SET** (by the stood-down 17:xx lead, at 90 % of the 5-hour window): one-time task
  `resume-appleengineeringsystem-287007` fires **21:53 local** (reset 21:50 + 3 min) and continues NEXT below
  (Decision 006 step 3). Keep-awake holds to 22:38. Xcode now permits the whole trial folder
  `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run` until 2026-11-27 19:47 local (owner ran `sudo xcrun
  mcp-server allow-folder --for-24-hours …`; two entries, both valid). ARMS.md's command lacks the required
  `--for-24-hours` or `--always` flag: note it as a correction, don't edit the frozen ARMS.md.

- **HAND-OFF 2026-11-26 19:2x** (lead: scheduled run 2 of `next-lead-appleengineeringsystem-287007`). Plan usage
  5-hour 86 % (resets 21:50 local), weekly 37 %; context 72 %. Stopped at the task boundary after step 2.
  Done: Decision 006 step 1 (2ec4c96, db3abe7) and step 2 (489ac7d). In flight: nothing. No lock held, no
  keep-awake hold. Still running on purpose: the assessor's MCP bridge daemon `trial005-run/tools/mcpd.py`
  (restarted 19:12, log `trial005-run/evidence/mcpd-restart-1912.log`), which the next lead can reuse through
  `tools/m`. **No next lead is scheduled**: updating the one-time task `next-lead-appleengineeringsystem-287007`
  needs a person's approval, which an unattended run cannot give (a phone notice was tried but not delivered:
  Remote Control inactive). Next steps in
  order: step 3, then step 4, then the recommendations, as the bullets below say. The owner can start them by
  re-arming that task (fire after 21:50) or by starting a fresh AES lead in this work tree. Owner question: Trailhead
  builder (still open). Live yes: Decision 006 (see Live yeses).
- 2026-11-26 19:1x (lead: scheduled session `next-lead-appleengineeringsystem-287007`, run 2, same work tree).
  **Decision 006 step 1 is DONE** and written up in the last section of `trial-005/RESULTS.md`: recordings, 24 matched
  states per arm, a six-launch cold-launch series per arm, and a label on every finding. It ran in one lock window
  (holder via turn-holder + quiet.sh, 19:00:31–19:07:47, released; heavy lane idle after) on `iPhone 18 Pro Max` only.
  Dynamic Type `large` and appearance `light` were restored and checked. Arm-v02 is left installed. Evidence (never
  publish): `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/assess/step1/` (scripts in `bin/`).
  Headlines: v02's Cancel-to-medium was reproduced a third time; the ~11 s cold-launch grid did not come back (first
  launch after install: tiles at 4.6 s control, 5.6 s v02; relaunches 1.3–1.8 s); no on-screen keyboard in either arm
  (Sim/Auto, cause not established).
- 2026-11-26 19:2x: **Decision 006 step 2 is DONE**: `DEVICE-INTERACTION.md` (linked from README). Xcode writes its
  own Claude plugin on request (`xcrun mcpbridge run-agent plugin path --plugin-format claude`); `claude --plugin-dir
  <that path>` loaded it (2 Haiku runs, ~$0.008), with 15 skills and the connected `xcode` server. 15 examples ran
  in one lock window, 19:12:53–19:13:50 (an earlier 8 s window at 19:12:16 was aborted because the assessor's
  `mcpd.py` bridge had exited; it was restarted). Evidence:
  `~/Scratch/AppleEngineeringSystem/2026-11-26-d006-step2/` (`ex/`, `examples.py`, `load-check*.jsonl`).
  Findings that matter for step 3: StartSession's reply says the agent MUST spawn a subagent with the
  device-interaction skill, and the skill calls the tool `DeviceEventSynthesize` (the real name is
  `DeviceInteractionSynthesize`). The Trial 005 arms had the `xcode` MCP server but not Xcode's plugin skills.
- **NEXT: Decision 006 step 3** (premature completion: why each arm stopped within nine minutes; separate missing
  tool knowledge, missing acceptance criteria, inadequate runtime inspection, unused diagnostic paths, genuine
  limits and legitimate stops). Sources: the arm transcripts `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/arm-*.jsonl`
  (parse them by script; never publish them), each arm's final message and NOTES.md, `trial-005/participant/` (what
  they were told), and RESULTS.md's existing notes. Write the analysis to `trial-005/COMPLETION.md` without
  proposing extra reporting or more time as the fix. Then step 4.
- Hand-over 19:1x (task boundary after step 1; context 59 %, plan usage 5-hour 77 %, weekly 36 %, 5-hour reset
  21:50 local). **The hand-over FAILED**: updating the scheduled task `next-lead-appleengineeringsystem-287007`
  needs a person's approval, and nobody had opened this unattended run. So no next lead is scheduled and the
  keep-awake hold was ended. This lead went on with step 2 in the same session (context had room). Nothing else
  running at 19:1x, no lock held.

- 2026-11-26 18:4x: **Director Decision 006 is CONFIRMED by the owner** in this lead's chat ("Yes, confirmed").
  The text is verbatim in `directives/DECISION-006.md`. No step has been started yet. **NEXT: a fresh lead (scheduled
  task `next-lead-appleengineeringsystem-287007`, fires 18:5x, see below) starts with Decision 006 step 1 (the gaps
  listed next), then steps 2, 3 and 4 in order.** This lead ended at the task boundary (context ~72 %).
- Step 4's budget is not set in the decision. Lead's pick, unless the owner says otherwise: the same 60 minutes and
  the same launch configuration as a Trial 005 arm (`trial-005/ARMS.md`). Run it outside the session (R9 nohup/setsid
  plus keep-awake), and only when usage has room.
- Decision 006 step 1 compared with what is done (the 18:10–18:27 window below): done are C1–C12 for both arms, with
  hierarchy evidence, console findings (unified log), Time Profiler and hangs, and a few screenshots per arm. Still
  missing: interaction recordings (`simctl io <udid> recordVideo` inside the window); a matched screenshot set per arm
  (same states, same order); each finding labelled as an app defect or a tool, simulator or automation limitation
  (candidates for limitation: `applicationState: NotRun`, marker frames not changing on selection, captures that come
  before an animation ends, glyph-sized control frames, hangs during the first MCP activation); and a cold-launch
  measurement beyond one first launch (arm-v02 showed an empty map grid for ~11 s, once, after install).
- Section 6 (now confirmed) settles owner questions 2–4: keep the stray MCPVerify DerivedData and Xcode's preview
  device clone (removal needs separate authorization), and leave developer mode off. Question 5 (Trailhead builder)
  stays open.
- Order: step 1 gaps (one lock window) → step 2 (find where Xcode installs the device-interaction skill;
  verified examples for tap, text, scroll, multi-point drag, reversal, screenshot, hierarchy; no copy of the whole
  skill) → step 3 (premature-completion analysis from the transcripts; notes so far are in RESULTS.md) → step 4 (a
  NEW isolated copy of arm-v02 at participant commit `7caa43b`; it must not see RESULTS.md, CHECKS.md or assessor
  findings; record its results separately) → recommendations for the next AES revision. Section 5: never publish the
  recording, the `work/ref/` frames or personal geographic information.

- 2026-11-26 18:3x (lead: scheduled session `next-lead-appleengineeringsystem-287007`, same work tree). **Trial 005
  is fully scored.** Runtime checks C1–C12 ran for both arms in one lock window (holder process, 18:10:36–18:26:39,
  released; heavy lane idle after) on `iPhone 18 Pro Max` only, and are written up in the last section of
  `trial-005/RESULTS.md` (status line updated). Evidence: `~/Scratch/AppleEngineeringSystem/2026-11-26-trial005-run/assess/`
  (per-arm `caps/`, `notes.md`, `c11-errors.log`, `c12.trace`, `c12-triage.txt`; never publish). Dynamic Type
  (`large`) and appearance (`light`) were restored and checked. Arm-v02's build is left installed on the simulator.
  In brief: both arms pass C1–C4, C6, C7, C9–C11; arm-v02 fails part of C5 (Cancel goes to the middle height); both
  are partial on C8 with different defects; C12 does not separate them. No superiority claim.
- Deviation logged in RESULTS: C11 used `simctl … log show`, because `GetConsoleOutput` needs an open Xcode workspace.
- (Superseded at 18:4x by the confirmed Decision 006 above. Nothing is running.)

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

- 2026-11-26 18:4x: Director Decision 006, confirmed by the owner in the lead's chat: steps 1–4, the deliverables and
  the constraints in `directives/DECISION-006.md` (sections 5–6 included). Every simulator step runs in a lead-held
  lock window on `iPhone 18 Pro Max`. Decision 005's yeses still apply to Trial 005's setup.

- 2026-11-26: Xcode MCP in both Trial 005 arms; the owner approves the agent in Xcode when prompted.
- Brief (Assignment 004 + supplement): work on branch `aes-v0.2` and publish it after review; never touch `main`,
  eDraft, Code Director, Draft Desk or the Folio submissions.
