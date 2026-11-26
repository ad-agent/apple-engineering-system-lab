# v0.2 activation check (knowledge delivery only)

This checks that the revised SKILL.md makes the agent read the relevant references and not the others. It says
nothing about application quality.

## Setup

- Two disposable projects in `~/Scratch/AppleEngineeringSystem/2026-11-26-v02-activation/`, each a git repo with
  `Sources/ContentView.swift` (a 60-row `NavigationStack` list) and `Sources/NoteStore.swift` (a word counter), and
  v0.2 copied to `.claude/skills/apple-product-engineering`.
- Claude Code 2.1.311, `claude-opus-5-5`, headless:
  `claude -p "/apple-product-engineering <task>" --strict-mcp-config --allowedTools "Read,Edit,Write,Glob,Grep,Skill" --disallowedTools "Bash,WebFetch,WebSearch,Agent" --permission-mode acceptEdits --max-turns 30 --output-format stream-json --verbose`.
- Both tasks say "Do not build or run anything; source changes only", to keep the check about reading.
- Traces summarised with [evidence/activation_trace.py](evidence/activation_trace.py). Transcripts are kept locally,
  not published (they contain local configuration).

## Results

| Run | Task | SKILL.md body injected | References read (order) | Not read | Other guidance consulted | Outcome |
|---|---|---|---|---|---|---|
| T1 interaction (user settings loaded) | Drag the list right to reveal a filters sidebar; reversible before release; light haptic on open | yes (session transcript `8814e0b7…`) | interaction, haptics, native, preservation | reference-analysis, product, runtime | SDK `.swiftinterface` greps for `UIGestureRecognizerRepresentable`, `sensoryFeedback`, `interpolatingSpring`; Xcode's bundled `swiftui-specialist` references | `ContentView.swift` +192/−5; 26 turns, 9 min 29 s; report separates source-only claims from unobserved behavior |
| T2 unrelated, first attempt (user settings loaded) | Fix `wordCount()` counting empty strings | yes (`678b42ba…`) | none | all 7 | — | Did not start: the owner's session-start layout hook flagged the scratch folder and the agent asked for a decision. Not a skill effect |
| T2 unrelated, rerun with `--setting-sources project` | same | yes (`b28e970a…`) | none | all 7 | — | One-line fix (`split(whereSeparator: \.isWhitespace)`); 3 turns, 11 s |

The stream-json output does not include the expanded slash-command body; injection was confirmed in the client's own
session transcripts under `~/.claude/projects/` (two lines each containing the SKILL.md heading).

## Reading

- Selective loading worked in this pair: the interaction task read the four references mapped to gesture,
  haptic, native-component and existing-design work, and the model-code fix read none, as SKILL.md's table says.
- T1 read preservation.md although the task is an addition to a plain list; the table maps "changing an app whose
  current design is accepted" there, so this is consistent.
- T1 also used the Apple-provided `swiftui-specialist` files that only SKILL.md points to, which is a further sign the
  body was read.
- Compared with v0.1's trial, where no reference was read, this is the knowledge-delivery change the assignment
  asked for. One run per task; the result may vary between runs.

## Confounds and gaps

- T1 ran with the owner's user-level settings (global CLAUDE.md, the `loupe` user skill listed); T2's counted run did
  not. The `loupe` skill was not invoked in T1.
- Skill invoked explicitly by slash command; self-activation from the description alone was not tested.
- Codex not tested (not installed).
