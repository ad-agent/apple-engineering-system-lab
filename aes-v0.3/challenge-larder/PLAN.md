# Challenge: Larder (prepared under Decision 007 §7; not yet run)

A fresh native iPhone app with a product objective, built from scratch: a household food log that makes burst entry
after shopping fast and shows what to use soon. It goes beyond reproducing a reference. The participant must
understand a short recording, read user research, make product decisions the brief leaves open, build natively, and
refine the running app on its own.

## What each part exercises

| Part | Exercises |
|---|---|
| `participant/OBJECTIVE.md` | Four primary journeys stated as user goals, not screens; open product decisions |
| `participant/RESEARCH.md` | Fictional interview notes: the users' costs (burst entry, unknown dates, "use soon", undo, large text) |
| `reference/quick-entry.mov` (recorded by the lead before the first run; see below) | Reference understanding: what keeps multi-item entry fast (keyboard stays up, Return makes the next row) |
| `participant/larder-seed.json` | Fixture: 32 fictional items with relative expiry, loaded with `-LarderSeed`; written by the lead before any participant run, so no participant solution is involved. The Trailhead fixture question stays deferred: this challenge does not need it |
| `assessor/CHECKS.md` | Twelve checks written before any run: five journeys with end states, three for every user, four for native quality and product decisions |

## Arms and pairs

- **Arms.** `v03`: the AES v0.3 skill in `.claude/skills/`. `control`: no AES skill. Both arms load Xcode's plugin with
  `--plugin-dir "$(xcrun mcpbridge run-agent plugin path --plugin-format claude)"` and get the same Xcode MCP server,
  so the only difference is AES. Same model (Opus 5.5), same tools (`Bash,Read,Edit,Write,Glob,Grep,Skill,mcp__xcode-tools`;
  no Agent), same rules file, same prompt, same 30-minute `timeout 1800`.
- **Pairs.** Two pairs minimum before any comparison (RECOMMENDATIONS.md). Order inside each pair by coin flip,
  logged. One run at a time on `iPhone 18 Pro Max` (the shared lock serialises them anyway).
- **Starter.** One template project committed once; each run gets a fresh `git clone` of it in
  `~/Scratch/AppleEngineeringSystem/<date>-larder-run/<label>/` with the arm's inputs added in a second commit.

## Assessment

- An assessor runs `assessor/CHECKS.md` by one script, unchanged across runs, after all four runs. Apps are given
  neutral labels (coin flip); the assessor gets the label and the installed build, not the arm. It may read
  NOTES.md (C12) but not the transcripts.
- Results go into `RESULTS.md` per run, then a pair-by-pair comparison. No claim beyond what the pairs show.
- The lead also counts, from transcripts: hierarchy reads, starting states per journey, AX5 and dark passes, owner
  questions, stop time against budget, and the unverified list against the agent's own conditions (the Decision 006
  deficiencies).

## Budget

At the Trial 005 rate (about 2 % of the Pro 5-hour window per minute of Opus run), one 30-minute run uses about
60 % of a window. So one run per window, four windows for two pairs, plus one short assessor window: roughly a
quarter of a weekly allowance. Start each run just after a 5-hour reset. If a run is cut by a usage limit, record
"budget exhausted"; do not rerun it without the owner.

## Before the first run (lead)

1. Record the reference: in the heavy lane, a 20–30 s simulator recording of a first-party list app adding four or
   five items in a row with the keyboard up (no personal data; status bar overridden). Keep it in
   `~/Data/AppleEngineeringSystem/larder/reference/` and never publish it.
2. Starter: done. [starter/Larder/](starter/Larder/) is Xcode's iOS App template (iOS 27.2, bundle `test.aes.Larder`)
   with `larder-seed.json` in the app folder and `RESEARCH.md` at the root. Built on 2026-11-27 for `iPhone 18 Pro Max`
   (BUILD SUCCEEDED; `larder-seed.json` is in the built app). Commit it once in the run folder as the starter commit.
   Copy `participant/OBJECTIVE.md` and `participant/CLAUDE.md` into each run folder, and name the UDID in the prompt.
3. Check isolation. Headless `claude -p` here also loads the owner's `~/.claude/CLAUDE.md` (seen in the Decision 007
   probes: answers cited R1, R8 and R10). `--setting-sources project` does not prevent it and `--bare` needs an API
   key. It affects both arms equally; record it in each run's setup, or run with an API key under `--bare` if the
   owner provides one.

## Not measured

Feel, animation quality and haptics (no physical device). Whether the app would succeed with real households.
