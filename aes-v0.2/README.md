# AES v0.2 (development branch `aes-v0.2`)

v0.1 in [`../aes/`](../aes/) and all trial evidence are unchanged. This folder holds v0.2 alongside it.

**Status: unscored.** v0.2 changes what knowledge reaches the agent and how specific it is. No application trial has
run with it, so nothing here shows that it improves engineering quality.

## Contents

| Path | What |
|---|---|
| [skills/apple-product-engineering/](skills/apple-product-engineering/) | The skill: `SKILL.md`, 7 references, 2 examples. Install by copying the folder to a project's `.claude/skills/` (Claude Code) or `.agents/skills/` (Codex) |
| [v0.1-to-v0.2.diff](v0.1-to-v0.2.diff) | Full diff of the skill against v0.1 |
| [FOLIO-FINDINGS.md](FOLIO-FINDINGS.md) | 17 findings from both Folio arms, each demonstrated, inferred or unresolved |
| [TOOLS.md](TOOLS.md) | Verified Xcode MCP inventory, Xcode's bundled agent guidance, third-party tools reviewed, what AES adds |
| [DEVICE-INTERACTION.md](DEVICE-INTERACTION.md) | Where Xcode installs its device-interaction guidance, how an agent loads it, verified interaction examples (Decision 006 step 2) |
| [trial-005/COMPLETION.md](trial-005/COMPLETION.md) | Why both Trial 005 arms stopped within nine minutes, cause by cause (Decision 006 step 3) |
| [ACTIVATION.md](ACTIVATION.md) | Selective-loading check on two disposable projects |
| [trial-005/PLAN.md](trial-005/PLAN.md) | The next application trial, designed but not frozen |
| [evidence/](evidence/) | MCP tool list, edge measurement CSV |

## Changes against v0.1, and the decision each one targets

| Change | Decision it should improve | Source |
|---|---|---|
| SKILL.md rewritten around a "read before you decide" table: problem category → reference, read once before the first committing edit, named in the first progress note | Specialist knowledge was never consulted in Experimental B | Finding 1 |
| SKILL.md lists Xcode 27's bundled Apple guidance and the Xcode MCP tools, read and used in place | Re-deriving what Apple already documents; checking APIs from memory | TOOLS.md |
| Hard rules: never loosen an assertion; report every warning and stall with baseline counts; separate compliance from autonomy | B removed an assertion, did not report a warning or stalls, and had rule deviations alongside "no interventions" | Findings 10–12, 15 |
| native.md: a four-step test of whether a system component suffices; verified availability table (iOS 27.2 SDK); observable identity, focus, selection, scroll and undo, each with a check; one navigation owner | Custom machinery replacing system controls; `.id` changes that dropped focus | Findings 13–14 |
| preservation.md: creation versus refinement; visual, behavioral and data invariants; equivalent named states with pinned clock, keyboard and caret | Before/after comparisons of different states (B's notes 592 vs 582) | Folio evidence |
| interaction.md: four phases with a check for each; target versus presentation value; why closed-form estimates diverge (measured); readable-presentation options; coordinate space, velocity units, arbitration, geometry changes, stale completions, accessibility; how to execute reversal and interruption | Model-only verification of reversal, flick and interruption; an estimate that cannot match the drawn surface | Findings 2–9, 17 |
| haptics.md: event table, one owner per event, false confirmation cases, an evidence ladder from logged request to device | Haptics claimed from code only | Finding 16 |
| runtime.md: four kinds of evidence; resource rules apply to MCP tools; the refinement loop with a stop rule; which tool observes what; methods for pre-existing versus introduced, XCTest stalls, runtime warnings and regressions | Green tests taken as product quality; unexplained stalls and warnings | Findings 5, 10–12 |
| New reference-analysis.md: reading screenshots and recordings as experiences, observed/inferred/unknown, requirements you can check | Supplement 004b §2 | — |
| New product.md: finding the user's cost, how Apple's apps resolve it, when a new interaction is justified | Supplement 004b §3 | — |
| examples/spring-estimate (Swift, executed): closed-form spring versus SwiftUI `Spring`, and the size of three divergences | Establishes that the arithmetic matched and the assumptions failed | Findings 2–4 |
| examples/edge-track (Python + ffmpeg, executed on trial recordings): per-frame edge position | Turns "looks smooth" into a measurement; found a release discontinuity and a transcode artefact | Findings 6, 8, 9 |
| Removed: mission statements, the closing maxim, the five-part rationale required for every refinement, repeated scope language | v0.1 audit: these did not change a decision | `evaluation/aes-v0.1-audit.md` |

Size: v0.1 was 1,573 words in total. v0.2 is 5,451, but a task loads the core (765) plus the references it needs.
In the activation check (ACTIVATION.md) that was the core plus 4 of 7 references for the interaction task and the
core alone for the unrelated one.

## Known limitations and unverified claims

- No application evidence for v0.2. Trial 005 is designed, not run.
- Activation was checked on Claude Code only (Codex CLI is not installed), with one run per task, headless.
- Xcode MCP was executed on 2026-11-26 (MCP-VERIFIED.md): documentation, project tools, build diagnostics,
  previews, simulator interaction and console work. The debugger does not attach on this Mac (developer mode is
  off), hitch measurement needs a physical device, and the tools ignore the shared lock and reset the run
  destination to an eDraft simulator on every open, so containment depends on project rules.
- Interaction guidance on SwiftUI's handling of a non-animated write during an in-flight animation is unresolved
  (Finding 17).
- `examples/spring-estimate` checks SwiftUI's spring model, not rendering. `edge_track.py` finds the strongest
  brightness step in a band; it needs a band where the moving edge is the strongest edge.
- The Apple-app patterns in product.md are from general knowledge and should be checked in the apps, as the file
  itself instructs.
- API availability was checked against the iOS 27.2 SDK only; macOS was not checked.
