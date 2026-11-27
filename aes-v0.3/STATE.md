# AES v0.3 — state

## Top block (read first)

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
