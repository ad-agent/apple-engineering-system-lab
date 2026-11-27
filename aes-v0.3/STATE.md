# AES v0.3 — state

## Top block (read first)

- **LARDER RUNS — OWNER YES 2026-11-27 08:1x, in chat: "Start the runs"** (two pairs of 30-minute runs, one run per
  5-hour window, then the assessor; `challenge-larder/PLAN.md`). Prepared by the D007 lead: reference recorded
  (`~/Data/AppleEngineeringSystem/larder/reference/quick-entry.mov`, sha256 `bef0f033…`, Reminders quick entry at 3×;
  never publish); run folder `~/Scratch/AppleEngineeringSystem/2026-11-27-larder-run/` with starter `dbf9109`, four
  frozen clones `run-A`…`run-D` (inputs committed), `coin-flip.log` (labels → arms; the assessor must not see it),
  `mcp.json`, and `launch.sh <label>` (detached, `timeout 1800`, keep-awake, writes `<label>.start/.pid/.jsonl/.err/.end`).
  Order: run-A, run-B, run-C, run-D. **Each lead in the chain:** (1) `list_sessions {"linked": true}` and stand down if
  another AES lead is live; (2) if the previous run's `.end` exists, record one line here (label, start, end, result
  subtype, turns, whether it committed, whether `.hold` was left — remove a leftover `.hold` only after its process
  is gone) and check the clone's commit; never open the transcript beyond that (the assessor scores later); (3) if
  `get_usage` shows the 5-hour window under 20 % and no run is in flight, `./launch.sh <next label>`; after 3 min,
  check `<label>.jsonl` for an Xcode approval or allow-folder error (if so: stop the run, record it, phone notice to
  the owner); (4) re-arm `resume-appleengineeringsystem-287007` (update, never a second task) at the window's
  `resetsAt` + 3 min, hold the Mac awake to it, check `list_scheduled_tasks`; (5) commit this file, push `aes-v0.3`
  (verify branch and nonempty source; no force), end. After run-D ends: the assessor step (PLAN.md "Assessment") in
  a fresh lead, blind to arms, then RESULTS.md. A usage-cut run is "budget exhausted", never rerun without the owner.
  **Done by the owner (reported in chat 2026-11-27 08:2x: "Done, it's allowed"; valid ~24 h):** `sudo xcrun mcp-server allow-folder --for-24-hours ~/Scratch/AppleEngineeringSystem/2026-11-27-larder-run`
  (Trial 005 needed the same; an unattended run cannot answer Xcode's approval). **Renewed by the owner 2026-11-27
  13:55 ("allowed … (24 hours)"), so it now lapses about 13:55 on 2026-11-28.** If it lapses before the assessment
  ends, the owner reruns it. Side effect noted: the reference recording left five reminders and a Contacts "Don't Allow" in
  the `iPhone 18 Pro Max` simulator's Reminders app.
  **RECURRING TASK — OWNER YES 2026-11-27 13:5x, in chat:** "configure the existing AES scheduled task to continue
  the remaining experiments and independent assessment … Continue through runs B, C, D, the independent assessment and
  the consolidated final report without requesting routine intermediate decisions. Once the assignment is complete, do
  not launch additional experiments." `resume-appleengineeringsystem-287007` is now one recurring task (cron
  `43 * * * *`, dispatched at :51 by the app's jitter). Its prompt holds the whole procedure: gates (STATE, usage,
  another live session, keep-awake to the next firing), record, next run, blind assessment, final report, then
  "ASSIGNMENT COMPLETE" here and the task disables itself (or asks the owner to). No lead re-arms anything any more;
  the earlier one-time re-arms (refused when unattended, 11:4x) are superseded. No permission change was needed.
  **Run log:**
  - run-A: 2026-11-27 11:44:40 → 11:58:41 +0100; result `success`, 64 turns, 827 s, $1.98; committed (`574c354`);
    no `.hold` left.
  - run-B: 2026-11-27 13:53:04 → 14:01:31 +0100 (launched by the D007 lead at a 15 % window, PID 5184, same lane
    command as run-A); result `success`, 78 turns, 498 s, $2.42; committed (`de3c529`); no `.hold` left.
    Recorded by the hourly task at 14:5x.
  - run-C: 2026-11-27 16:52:17 → 16:59:17 +0100 (launched by the hourly task at a 0 % window, weekly 65 %; load
    4.99, memory pressure level 2 "warn"; heavy lane free; PID 37379, same lane command as run-A and run-B); result
    `success`, 79 turns, 414 s, $2.42; committed (`a18ea49`); no `.hold` left; `.err` empty. Recorded by the hourly
    task at 17:5x. (The 14:5x firing found the window at 51 % and waited.)
  - run-D: 2026-11-27 21:52:18 → 22:17:59 +0100 (launched by the hourly task at a 1 % window, weekly 78 %; load
    2.52, memory pressure level 2 "warn"; heavy lane free; PID 826, same lane command as run-A–C); result `success`,
    20 turns, 1531 s, $0.96; committed (`4f989a3` app, then `1785626`, `7ec12ed` NOTES); no `.hold` left; `.err`
    empty. The 17:5x firing found the window at 35 % and waited; the 19:5x and 20:5x firings stopped on the usage
    limit and wrote nothing. Recorded by the hourly task at 22:5x. **Deviation, from the result line only:** the
    participant reports it built the app but never ran it: it waited 21:54–22:17 for `/tmp/edraft-checks.lock`, which
    its own launcher (`lockf` → `turn-holder.sh` → `launch.sh run-D`) held for the whole run, because the owner's
    global CLAUDE.md R8 (loaded by headless runs, PLAN.md "Check isolation") says every simulator action takes that
    lock. Its journeys are unverified at runtime by its own account. Not rerun: a rerun would change the conditions
    and needs the owner. Whether run-A–C met the same wait is a transcript count for the final report, read only
    after scoring. The assessor's prompt says it already holds the heavy turn, so it cannot meet the same deadlock.
  **Assessment log (blind; labels only):**
  - Builds, 22:54–22:55 in the heavy lane (load 4.62 → 6.75): `assess-build/build.sh <label>` exports each clone's
    committed tree without `.claude/` (`git archive HEAD`) and runs one `xcodebuild … -derivedDataPath
    assess-build/<label>/dd build`. All five BUILD SUCCEEDED: starter `dbf9109` 0 warnings; run-A `574c354` 0; run-B
    `de3c529` 0; run-C `a18ea49` **4** (all in `Intents.swift`, Swift 6 concurrency: missing `await`, main-actor
    properties from a nonisolated context); run-D `7ec12ed` 0. No project has a test target, so "its tests pass" has
    nothing to run (C11's build part, scored by the lead). Logs: `assess-build/<label>/build.log`, `warnings.txt`.
  - `assess/<label>/` holds only `Larder.app` and `NOTES.md` (from the commit). `assess/ASSESSOR.md` is the one
    assessor script (fixed order of the twelve checks, fixed 10 item names for C1, one C10 method, writes
    `assess/<label>/SCORES.md` as it goes, scores C11's runtime part only); `assess/CHECKS.md` is an unchanged copy;
    `assess/assess.sh <label>` resets the simulator (uninstall, light, `large`), records the load in `<label>.load`
    and starts `claude -p` with launch.sh's flags (timeout 1800, same model, plugin, mcp.json, tools).
  - Rule for starting an assessor run: the same as for the runs (5-hour window under 20 %, weekly under 90 %), one
    label per firing, order run-A, run-B, run-C, run-D. The 22:5x firing found the window at 53 % (PLAN.md's rate
    puts a 30-minute Opus run near 60 %) and waited. Next firing: if the gates allow, start run-A's assessor with the
    lane command below, using `cd …/assess && ./assess.sh <L>` in place of `./launch.sh <L>`, lane log
    `assess/<L>.lane.log`; after 3 min check `assess/<L>.jsonl`/`.err` for an Xcode approval error. When `<L>.end`
    exists: copy the facts from `SCORES.md` and the `.load` lines into this log, then the next label.
  **How runs are launched (keep the same for B–D, so the arms run under the same conditions):** inside the heavy
  turn and quiet lane (R8), detached, so `launch.sh`'s `.end` watcher survives the session:
  `nohup perl -e 'use POSIX qw(setsid); setsid(); exec @ARGV' /usr/bin/lockf -k /tmp/edraft-checks.lock
  ~/Developer/codedirector-briefs/tools/turn-holder.sh "AES lead: Larder <L>" ~/Developer/codedirector-briefs/tools/quiet.sh
  "AES lead: Larder <L>" sh -c 'cd ~/Scratch/AppleEngineeringSystem/2026-11-27-larder-run && ./launch.sh <L> && PID=$(cat <L>.pid)
  && while kill -0 $PID 2>/dev/null; do sleep 20; done' </dev/null > <run folder>/<L>.lane.log 2>&1 &`.

- **HAND-OFF 2026-11-27 (Decision 007, lead session in work tree `.claude/worktrees/aes-v0.3-d007`, branch
  `aes-v0.3`, the only writer and publisher of that branch).** Decision 007 is done except what is listed under
  "Next". Delivered: the v0.3 skill (`skills/`), `v0.2-to-v0.3.diff`, `VERIFICATION.md` (Apple integration, matched
  probes P1–P5, runtime runs E1, E1b and E1c), the Larder challenge (`challenge-larder/`), README with known limitations.
  The branch's exact commit is in git log and in the owner's report. In flight: nothing. No lock held. Private
  evidence: `~/Scratch/AppleEngineeringSystem/2026-11-27-d007-probes/` and `…/2026-11-27-larder-starter-build/`
  (never publish).
- **Next (Decision 007 §7 covers preparing the challenge, not running it):** before the first Larder run, record the
  reference (`challenge-larder/PLAN.md`, "Before the first run" step 1). Then two pairs of 30-minute runs, one run
  per 5-hour window, then the assessor. Owner questions: (a) start the Larder runs now under Decision 007's standing
  authority, or wait for a decision; (b) an API key for `--bare` runs, so the owner's global CLAUDE.md stays out of
  participant runs (optional; the confound is equal across arms). Deferred, not blocking: the Trailhead fixture
  (question 5); Larder does not need it.
- **Layout check note:** the main tree is on `main` while `projects.tsv` names `aes-v0.2` as the active branch, and
  `aes-v0.2` is checked out in `.claude/worktrees/aes-v0.2` (stale at `982ea0a`; origin is at `b377a7a`). Not changed
  by this lead. If `aes-v0.3` becomes the active branch, update `projects.tsv`.
