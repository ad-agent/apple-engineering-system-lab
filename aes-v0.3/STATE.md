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
  (Trial 005 needed the same; an unattended run cannot answer Xcode's approval). If 24 h lapses before run-D, the
  owner reruns it. Side effect noted: the reference recording left five reminders and a Contacts "Don't Allow" in
  the `iPhone 18 Pro Max` simulator's Reminders app.
  Armed: `resume-appleengineeringsystem-287007` fires 2026-11-27 11:43 CET (keep-awake hold to 12:28) to launch run-A.

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
