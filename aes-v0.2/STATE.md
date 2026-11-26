# AES v0.2 — state

Updated 2026-11-26 by the AES v0.2 lead session (Claude Code desktop).

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

## Next steps (in order)

1. Owner decisions: (a) approve Xcode MCP for agents in Xcode, or keep it off, for both trial arms alike;
   (b) who builds the Trailhead fixture (proposed: Grok from `trial-005/PLAN.md`).
2. Build and freeze the fixture; reproduce the AX5 filter-sheet defect under `/usr/bin/lockf -k /tmp/edraft-checks.lock`.
3. Capture the Maps reference recording; write participant and assessor files; hash; freeze.
4. Run pairs headless with `--setting-sources project` and `timeout 3600`; score blind.
5. Settle Findings 7, 11 and 17 (methods in FOLIO-FINDINGS.md) when the simulator lane is free.
6. Check Codex activation when a Codex CLI is installed.

## Owner questions

- Xcode MCP approval (step 1a). Using it in trials also needs a rule for the shared lock: the tools build and run
  outside `lockf`.
