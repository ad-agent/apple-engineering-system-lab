# AES v0.3 (development branch `aes-v0.3`)

Director Decision 007 ([directives/DECISION-007.md](directives/DECISION-007.md)). Built from
[../aes-v0.2/RECOMMENDATIONS.md](../aes-v0.2/RECOMMENDATIONS.md). v0.1 (`../aes/`), v0.2 (`../aes-v0.2/`) and all
trial evidence are unchanged.

**Status: verified as a skill, unscored as an app-quality change.** The checks in VERIFICATION.md show what the
skill makes agents do. No application trial has run with v0.3, so nothing here shows that it makes better apps.

## Contents

| Path | What |
|---|---|
| [skills/apple-product-engineering/](skills/apple-product-engineering/) | The skill: `SKILL.md`, the same 7 references and 2 examples as v0.2. Install by copying the folder to a project's `.claude/skills/`; load Xcode's plugin with `claude --plugin-dir "$(xcrun mcpbridge run-agent plugin path --plugin-format claude)"` |
| [v0.2-to-v0.3.diff](v0.2-to-v0.3.diff) | Full source diff of the skill against v0.2 |
| [VERIFICATION.md](VERIFICATION.md) | Apple integration and retrieval checks, matched behavioural probes, runtime-criticism runs on a real app |
| [challenge-larder/](challenge-larder/) | The next application challenge, prepared and not yet run: brief, research notes, starter project with fixture, sealed assessor checks, plan |
| [evidence/](evidence/) | `check_apple_refs.sh` and its output |

## What changed against v0.2

| Change | Decision 007 / recommendation |
|---|---|
| SKILL.md §1: find Xcode's plugin with `plugin path` each time; one table maps each task to the Apple skill (`xcode-integration:…`) and the AES reference to load before deciding. Replaces v0.2's list of `IDEIntelligenceChat` resource files, which are now `.packaged` and unreadable (the `AdditionalDocumentation` Markdown is kept) | §1; R1 |
| Description also triggers before driving the app with Xcode's device tools, so the verified corrections are read (probe P1) | §1 corrections |
| runtime.md "Driving the app": follow Apple's `device-interaction`; seven verified corrections and the verified command forms; other routes when the tools fail. Replaces v0.2's tool table, which repeated Apple's guidance | §1; R1 |
| SKILL.md step 2 and reference-analysis.md: each primary journey written as start → action → expected end state from the reference, with the usability principle it serves; product descriptions as references | §2; R2 |
| product.md: seven lenses (continuity, navigation, context, hierarchy, responsiveness, accessibility, native integration) for finding the user's cost; no decorative customisation | §2 |
| runtime.md: proportionate check selection by task; journeys from more than one starting state, hierarchy compared by script; AX5 and dark in the running app, VoiceOver read of labels, Apple's accessibility skills for causes; measure before reporting slowness; tool success is not user success | §3; R3 |
| SKILL.md §3: essential / polish / device-only; an unverified essential condition is unfinished work; a blocker only after the tool's own guidance and one other route; in an evaluation, the "not checked" list is compared with the essential conditions before stopping; the clock is read before "out of time"; no spending budget for its own sake | §4; R4 |
| SKILL.md step 1: routine choices are the agent's; only money, keys, deleting user data, security, publishing or project rules need the owner | §5; R5 |
| interaction.md, native.md, haptics.md, preservation.md: pointers to the Apple skills that now cover their API details; v0.2's "not yet verified" note on multi-point drags replaced by the verified forms | §6 remove obsolete |

## Known limitations

- Every agent check is one run, on Opus 5.5, on one Mac, and loaded the owner's global `~/.claude/CLAUDE.md` (see
  VERIFICATION.md). Behaviour shown once is not a rate.
- E1, E1b and E1c evaluated an existing app; no v0.3 run has built or refined one. The comparison with v0.2's earlier runs
  on the same app is not matched.
- The Apple skill names and corrections were checked on Xcode 27.2 (27B52). A new Xcode may rename skills or fix the
  tools; rerun `evidence/check_apple_refs.sh` and the P1 probe after an update.
- The skill grew from about 5,450 to 6,540 words, mostly the Apple routing table, the corrections and product.md's
  lenses; the duplicated tool table and resource list were removed.
- Feel, animation quality and haptics remain unverifiable without a physical device.
