# Recommendations for AES v0.3 (Decision 006, last deliverable)

Written 2026-11-26 by the AES lead from four records: [trial-005/RESULTS.md](trial-005/RESULTS.md) (the assessor's
C1–C12 and finding labels), [trial-005/COMPLETION.md](trial-005/COMPLETION.md) (why both arms stopped),
[DEVICE-INTERACTION.md](DEVICE-INTERACTION.md) (Xcode's own device guidance, verified) and
[trial-005/REFINEMENT.md](trial-005/REFINEMENT.md) (the separate refinement run and the assessor's check of it). The
sections follow the owner's five priorities for v0.3 in [directives/AUTHORITY-006.md](directives/AUTHORITY-006.md).

**What this rests on.** One Trial 005 pair (one run per arm) and one refinement run of one arm, with different
guidance and a different instruction. That is enough to name specific failures and their causes. It is not enough to
say whether AES v0.2 makes apps better than no skill, and nothing here claims that. Each recommendation names its
evidence, what it would not fix, and how the next trial can check it. None of them adds a skill file, a tool or
reporting; most change or remove existing lines.

## 1. Correct use of existing Apple tools: point to Xcode's own guidance

**Change.** In `SKILL.md` and `references/runtime.md`, replace the device-tool advice with one pointer: load Xcode's
plugin (`xcrun mcpbridge run-agent plugin path --plugin-format claude`) and follow its `device-interaction` skill,
with the three corrections in DEVICE-INTERACTION.md ("Three places where the guidance and the tools disagree"). Keep
the lock rule. Remove AES text that repeats Xcode's guidance.

**Evidence.** Both Trial 005 arms had the device tools and could not drive them. arm-v02 never made a multi-point drag
and could not type; arm-control found the drag by guessing and never typed (COMPLETION.md, gaps 1 and 2: missing tool
knowledge). The refinement run had Xcode's plugin loaded and a short method sheet. In 7 min 37 s it made 8 multi-point
drags and typed through `sender keyboard kbd` (REFINEMENT.md, transcript counts).

**Limits.** The refinement run also had a different instruction and started from a built app, so the plugin is not
isolated as the cause. It is one run. Tool skill alone did not catch the defects in sections 2 and 3.

**Check next time.** Count drags, typing and hierarchy reads in each arm's transcript, as COMPLETION.md did.

## 2. Reference-derived expectations for primary journeys

**Change.** `SKILL.md` work-order step 1 already says to write observable acceptance conditions before editing. Make
it concrete in one sentence: each primary journey of the brief is written as *starting state → action → expected end
state*, with the end state taken from the reference, not from the design (for example: "search started at the
smallest sheet height; Cancel; the sheet is back at the smallest height"). They stay in the agent's work notes; they
are not a deliverable.

**Evidence.** arm-v02 looked at the Cancel result and accepted it (COMPLETION.md). The refinement run had working
tools, ran the same journey and still missed it: it checked that the markers came back, not the sheet height. The
assessor then measured Cancel returning to the middle height 4 times out of 4 on the refined app (REFINEMENT.md, C5).
The assessor's own checks caught it because C5 states the expected end state ("cancel returns to the previous
height"). The reference recording shows search closing back to the map (assessor/CHECKS.md, O4).

**Limits.** A condition written from a wrong reading of the reference is still wrong; this only makes the end state
explicit enough to compare against.

**Check next time.** Whether each arm's notes hold end states for the primary journeys, and whether the C5-type
defects (wrong end state on a journey the agent ran) disappear.

## 3. Product-aware runtime criticism

**Change.** Two short additions to `references/runtime.md`, no new reporting:
- *System settings in the running app.* Step 1 suggests previews for text size and appearance, and none of the three
  runs checked Dynamic Type at all. Name the running-app route as well: walk the primary journeys once at
  `xcrun simctl ui <udid> content_size accessibility-extra-extra-extra-large` and once with `appearance dark`, restore
  both, and read the hierarchy's labels as VoiceOver would.
- *Inspection habits.* Read state from the hierarchy (focus, frames, counts), not from thumbnails. Run each primary
  journey from more than one starting state. Measure a suspected delay (repeated launches, timed captures) before
  reporting it.

**Evidence.** None of the three runs (two arms, one refinement) checked Dynamic Type, and all three were Partial on C8 at AX5
with defects a single pass shows: truncated labels and broken words in arm-control, overflowing row icons in arm-v02
and the refined app (RESULTS.md; REFINEMENT.md). All three share the minor C9 defects (placeholder-only search field,
default symbol names). The assessor's AX5 pass took about a minute per app (64 s and 68 s in its window log). COMPLETION.md
lists no hierarchy reads in arm-v02, one starting state per journey and an unmeasured cold-launch delay. The step 1
cold-launch series later found no app-specific delay in either arm. The refinement run did compare hierarchy
frames, and found its confirmed fix that way: the map no longer moves when the sheet changes height (REFINEMENT.md,
measured).

**Limits.** These catch layout, labelling and state defects. They say nothing about feel or animation quality.

**Check next time.** C8 and C9 results per arm, and whether the transcripts show an AX5 and a dark pass.

## 4. Evidence-based completion judgment: reword the stop rule

**Change.** `references/runtime.md` step 5 ends with "List what remains unverified", and `SKILL.md` step 6 has the
same three exits. Replace with: "An acceptance condition without runtime evidence is a reason to keep working, not to
stop. A blocker counts only after the tool's own guidance and one other route (for example an XCUITest) have both
failed. After a stop for budget or a blocker, list what remains unverified."

**Evidence.** arm-v02 stopped with its central gesture unverified, 51 minutes left and nothing escalated. Its stop is
consistent with reading the last sentence as a fourth exit (COMPLETION.md). Neither arm looked at the clock. The
refinement run, with tool skill in place, stopped with about 22 of its 30 minutes left and an unverified list that
named Dynamic Type and accessibility. The assessor then found two of the remaining defects in exactly those areas
(REFINEMENT.md). So the early stop is not only a tool problem.

**Limits.** Wording is the cheapest change and the least certain one: arm-v02 read a stop rule and did not follow it.
Section 2's written end states give the rule something concrete to check.

**Check next time.** For each arm: stop time against the budget, and its unverified list against its own conditions.

## 5. Independent decisions within established authority

**Change.** Where `SKILL.md` and `runtime.md` say "a blocker needs the owner", say what that means: a step outside
the project's authority, such as money, keys, deleting user data, changing security settings or the project's rules.
A routine engineering choice is not a blocker. The agent takes the reasonable default, writes the assumption in its
notes and continues.

**Evidence.** Weaker than the others, and not from the trial arms, which never escalated anything. In this project the
leads stopped several times to ask about routine choices, and the owner answered "why are you keep asking, for
permission I already said go ahead" (STATE.md, 2026-11-26 22:3x) and then recorded AUTHORITY-006.md. The evidence is
about the project's own process. It shows the cost of an unclear boundary, not the arms' behaviour.

**Check next time.** Count owner questions per run and how many of them were routine.

## What not to change

- **No more time.** Neither Trial 005 arm looked at the clock, and the refinement run stopped with most of its budget
  left. A longer budget alone would not have changed these stops.
- **No more reporting.** Decision 006 rules it out, and the records show that the agents already reported gaps
  honestly. The problem was treating the report as the end.
- **No new tools, agents or skill files.** Xcode's tools did what was needed once their own guidance was loaded
  (DEVICE-INTERACTION.md).

## For the next trial (design, not skill)

- Allow, in the folder rule, the files the tools write and Xcode's bundled guidance (COMPLETION.md, implication 5).
  The refinement run used this allowance.
- Record in each arm's setup whether the Agent tool is allowed: Xcode's device skill asks for a subagent.
- Keep the assessor blind to the arm where possible. The C1–C12 runs so far were not blind.
- Script the assessor's checks once and reuse them unchanged. The refinement check needed a second window because of
  two automation errors: typed wait suffixes and an `xctrace` attach without `--device` (REFINEMENT.md, deviations).
- Run cold-launch and performance measurements only on a quiet Mac. Record the load average and keep the start
  conditions the same; the refinement check's numbers could not be compared for exactly this reason.
- More than one pair is needed before any comparison between arms. One pair can show causes, not effects.
- Budget: at the Trial 005 rate (about 2.4 % of the Pro 5-hour window per minute) a 60-minute arm does not fit in one
  window (STATE.md, 2026-11-26). Start arm runs right after a reset, or state shorter budgets in advance.

## What stays unknown

- Whether any of these changes improves the final app. Only a new trial can show that, and it needs more than one
  pair.
- Physical feel, animation quality and haptics. The simulator and synthesized gestures cannot show them, and none of
  these records claims anything about them.
