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
