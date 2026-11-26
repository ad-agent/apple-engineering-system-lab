# Trial 005: why each arm stopped (Decision 006 step 3)

One pair of runs. This explains two stops; it does not rank the arms, and it makes no claim that v0.2 is better or
worse. Both arms ended by themselves (`success`), arm-control after 7 min 3 s and arm-v02 after 8 min 53 s, out of 60
minutes (`RESULTS.md`, Runs).

**Not for step 4.** This file names assessor findings. The step 4 agent must not see it, just as it must not see
`RESULTS.md` or `assessor/CHECKS.md`.

## Method and evidence

- A script turned each arm's stream-json transcript into a timeline: every tool call with its time from the start,
  every rejected call with the tool's error, and the arm's short progress messages. Arm-v02's transcript also carries
  short summaries of its reasoning. Arm-control's reasoning is not visible: its thinking blocks are empty. So for
  arm-control, *why* it did something is read from what it did and said, not from its reasoning.
- Also read: each arm's final message and `NOTES.md`, the brief (`participant/OBJECTIVE.md`, `participant/CLAUDE.md`),
  the v0.2 skill the experimental arm read, and the assessor results (`RESULTS.md`, including Decision 006 step 1).
- The transcripts, timelines and script stay private (`~/Scratch/AppleEngineeringSystem/2026-11-26-d006-step3/` and
  the trial run folder). Nothing below quotes them; command words are given as technical evidence.
- Labels: **observed** = seen in the transcript or results; **inferred** = our reading of why.

## What each arm did, in time order (observed)

| | arm-control | arm-v02 |
|---|---|---|
| Study and plan | 0–86 s: reference frames as contact sheets | 0–11 s: read 5 of the skill's 7 references (not haptics, preservation); 11–100 s: reference frames; at 53 s listed Xcode's bundled assistant resources (no device-interaction guidance there) |
| Write code | 86–157 s, 4 files | 102–176 s, 4 files |
| First build and launch | 163 s, 177 s | 178 s, 195 s |
| Interaction session | 206–389 s | 236–483 s (first ID refused as recently used) |
| `DeviceInteractionSynthesize` calls / rejected | 25 / 7 | 21 / 7 |
| Text entry | 4 guesses in 6 s (`type`, `help`, `k`, `i`), then dropped | 2 guesses (`type`, `k`) and one AppleScript keystroke (Simulator.app was not running), then dropped |
| Sheet drag | `s`, `d`, `swipe` rejected; `drag` accepted at 322 s; 4 drags in all | `s`, `d`, `d` with commas rejected (312–316 s); decided at 319 s that the drag syntax could not be found; one last `swipe` at 482 s, rejected |
| What it looked at | the tool's own screenshots; the tool's hierarchy twice (by `grep`) | its own `simctl` screenshots only; never read a hierarchy. At 259 s it chose not to read the tool's output files because they are outside the project folder |
| Console, recording, profiling, UI tests | none | 3 log queries; no recording, profiling or UI test |
| Code changes after looking | 2 rounds (tap targets, a toggle style, controls under the modes panel, row styling) | 4 changes (control gap, controls hidden under Map Style, filter drives the map, chips while focused) |
| Last action → stop | "final look" at 384 s; ended the session at 389 s; notes; end at 423 s | rejected `swipe` at 482 s; stopped at once; notes; end at 533 s |
| Mentions of time or budget | none | none |

Neither arm referred to the clock or to the 60 minutes at any point, so the budget played no part in either stop.
No usage limit, error or permission denial ended either run.

## Why each arm considered the work complete (inferred, from the order above)

Both arms stopped when they ran out of journeys they could drive by tapping. Neither had a written list of what the
app must do, and the brief ends on a deliverable ("Finish with a short `NOTES.md`"), so the run ended at the first
point where the tap-driven checks were green and every remaining gap could be written down as "not verified".

- **arm-control** stopped after a last look at the rebuilt app. By then its tap and drag checks had passed, and the
  one gap it knew of was typing. It stopped about 2.5 minutes after giving up on typing.
- **arm-v02** stopped immediately after a final failed drag attempt. The v0.2 skill's stop rule names three exits:
  every acceptance condition has runtime evidence, the budget is spent, or a blocker needs the owner. None held: the
  central gesture had no runtime evidence, 51 minutes were left, and nothing was escalated. The rule's last sentence,
  "List what remains unverified", is what the arm did instead. This is consistent with reading that sentence as a
  fourth exit.

## The three gaps Decision 006 names, by cause

### 1. arm-v02 never exercised the sheet drag

| Cause | Weight | Evidence |
|---|---|---|
| Missing tool knowledge | **Primary** | The tool rejects unknown commands and points to a device-interaction skill that the arms did not have. Xcode ships that skill in its own plugin (`DEVICE-INTERACTION.md`); its forms are `mt` keyframes, `t … f …` and `drag`. Both arms guessed mostly the same wrong words first. arm-control's `drag` was a lucky guess, not knowledge |
| Diagnostic paths not pursued | **Major** | Four attempts in two bursts of a few seconds. Not tried: the word `drag`; XCUITest (`press(forDuration:thenDragTo:)`), which the skill's runtime and interaction references name as the first way to drive a running app; `xcrun mcpbridge --help`, two levels of which lead to `run-agent skills` ("Inspect and export Xcode-provided skills") |
| Trial configuration | **Contributing** | Every successful `DeviceInteractionStartSession` reply said the agent MUST load the device-interaction skill and spawn a subagent. The skill was not installed and the subagent tool was not in the arm's `--allowedTools`, so the tool's own instructions could not be followed. The v0.2 interaction reference itself says the tool's coverage of multi-point paths was "not yet verified" |
| Genuine implementation limitation | **None** | The same tool drags the sheet: step 2's examples, and step 1, where arm-v02's sheet passed C2 (three heights, drags and reversals) |
| Legitimate stop | **No** | No blocker was established; the stop came 9 minutes into 60 |

Effect on the app: none found. The sheet is the system sheet and passed C2. The cost was evidence, not quality.

### 2. arm-v02 could not verify text entry

| Cause | Weight | Evidence |
|---|---|---|
| Missing tool knowledge | **Primary** | The text form is `sender keyboard kbd <text>`, which neither arm found |
| Inadequate runtime inspection | **Major** | The arm explained the missing on-screen keyboard as a connected hardware keyboard and did not check it. The hierarchy, which it never read, shows `Keyboard Focused` on the field, which would have shown that focus worked and only the input path was missing |
| Trial configuration | **Contributing** | A careful reading of "work only inside this folder" kept arm-v02 away from the tool's output files (screenshots, hierarchy, logs). arm-control read them. The rule allows "the simulator and Xcode through the tools", but does not say that the tools' own output files count |
| Missing product acceptance criteria | **Major, for this journey** | The search journey held the one app defect the assessor found in arm-v02: Cancel returns to the middle height, not the height where search began (C5; step 1 state 12; code sets `.medium`). The arm ran this exact journey at 419 s from the smallest height and accepted the result, because the expected result it checked against was its own design. Its reference notes never say where Cancel returns; arm-control's do ("the earlier height") |
| Genuine limitation | **Partly** | The on-screen keyboard does not appear in captures in either arm, for the assessor too (Sim/Auto, cause not established). Typing itself works through the tool |

### 3. arm-v02 reported an unresolved cold-launch delay

| Cause | Weight | Evidence |
|---|---|---|
| Diagnostic paths not pursued | **Primary** | Seen twice (blank for 5+ s), reported, not measured. Cheap paths were open: poll `simctl io screenshot` after a launch, relaunch without reinstalling, or the Time Profiler, which the skill names |
| Genuine limitation / not an app defect | **Outcome** | Step 1's six-launch series per arm found a first-launch cost common to both arms (tiles at 4.6 s control, 5.6 s v02) and fast relaunches (1.3–1.8 s). The delay was the environment, which the arm could have shown in about a minute |
| Legitimate stop | **Partly** | Reporting an unexplained observation honestly is right. Stopping without the one measurement that would have explained it is not |

## The six categories across both arms

| Category | arm-control | arm-v02 |
|---|---|---|
| Missing tool knowledge | Text entry; drag found by guessing | Drag and text entry |
| Missing product acceptance criteria | No written criteria; Dynamic Type left unchecked (C8 Partial: truncated labels at AX5) | No written criteria; accepted the Cancel defect it was looking at |
| Inadequate runtime inspection | Thumbnails over hierarchy; no console; no recording | No hierarchy; an untested keyboard explanation; one starting state per journey |
| Available diagnostic paths not pursued | XCUITest, mcpbridge help, a console read | XCUITest, mcpbridge help, the word `drag`, a launch-time measurement |
| Genuine implementation limits | Physical feel (velocity, haptics) cannot be judged in the simulator; both said so | The same |
| Legitimate reasons for stopping | The tap-driven journeys and drags held and were checked; gaps reported honestly; no polishing for its own sake | Gaps reported honestly; but the central gesture was unverified with no blocker shown |

## What this does and does not show

- Neither stop was caused by time. Neither arm looked at the clock, so a longer budget alone would not have changed
  either stop.
- The common root is that both arms stopped when nothing they *could* do was failing, and both counted a journey
  they *could not* drive as reported rather than open. With no written acceptance conditions, nothing marked the
  sheet drag or the Cancel return height as part of done.
- The pair does not show whether the v0.2 skill helped or hurt stopping. The experimental arm read the runtime
  method that names recordings, the hierarchy and XCUITest, and used none of them. One run cannot separate the
  skill's effect from chance, as arm-control's lucky `drag` shows.

## Implications for step 4 and the next AES revision (inputs, not decisions)

None of these adds reporting or time.

1. **Tool knowledge:** give the agent Xcode's own guidance the way `DEVICE-INTERACTION.md` describes (load Xcode's
   plugin, read the device-interaction skill). Step 4 does this. Check that the arm's allowed tools let it follow
   what that guidance requires, or note that the verified direct calls work without the subagent step.
2. **Acceptance conditions before the first build:** a short list of the brief's primary journeys, each with its
   expected end state taken from the reference, not from the design (for example, Cancel returns to the height
   where search began). This is what the stop rule checks against. It stays in the agent's work notes; it is not a
   deliverable.
3. **The stop rule's wording:** "List what remains unverified" should apply only after a stop for budget or a
   blocker. An unverified primary journey is a reason to keep going. A blocker counts only after the tool's own
   guidance and one other route (XCUITest) have failed.
4. **Inspection habits:** read the hierarchy for state (focus, frames, counts); run each journey from more than one
   starting state; measure a suspected delay before reporting it.
5. **Trial design:** a folder rule should say that the tools' own output files and Xcode's bundled guidance may be
   read. Otherwise the more careful agent is the one that loses evidence.
