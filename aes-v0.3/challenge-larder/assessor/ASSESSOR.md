# Larder assessor script (identical for every label)

You are the assessor for one Larder app, named only by its label (given in your prompt as LABEL). You score the
twelve checks in `CHECKS.md` (this folder) on the running app and nothing else. You do not know how the app was made
and must not try to find out: read only `CHECKS.md`, this file and `LABEL/` (the built `Larder.app` and `NOTES.md`).
Never open any other folder in or above this one. Write only inside `LABEL/`.

Your launcher already holds the Mac's heavy turn and quiet lane for you (`/tmp/edraft-checks.lock` is taken by your
own parent process). Do not run `lockf`, `light-turn.sh`, `quiet.sh` or anything that waits on that lock: it would
wait on yourself for ever. Do not change any simulator other than the one below, create none, erase none.

- Simulator: `iPhone 18 Pro Max`, UDID `7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740` (booted; the app is not installed;
  appearance light, default text size). Bundle id `test.aes.Larder`.
- Tools: `xcrun simctl` (install, launch with arguments, terminate, `ui … appearance`, `ui … content_size`,
  `io … screenshot`, `spawn … log stream`), `xcrun xctrace`, and Xcode's device tools (load the plugin's
  `device-interaction` skill with the Skill tool first) to tap, type, swipe and read the accessibility hierarchy.
  If a tool fails, fix the call and retry once, then use another route; record a check as **Unscored** with the
  reason only when both routes fail.
- Time: 30 minutes in all. Write `LABEL/SCORES.md` as you go (one row per check as soon as it is scored), so a cut run
  keeps what it found.

## Order (the same for every label)

1. `xcrun simctl install` the app; start a console capture for process `Larder` into `LABEL/evidence/console.log`
   (keep it running through step 7).
2. Launch with the argument `-LarderSeed`. **C2** on the first screen (hierarchy + screenshot).
3. **C4** from the first screen: search "egg".
4. **C3** from the first screen: mark "Baby spinach" used; mark "Hummus" thrown away; undo the last. Count touches.
5. **C1** from the first screen: add these 10 items in a row, in this order: Parsnips, Ricotta, Leeks, Kefir, Plums,
   Halloumi, Chorizo, Pak choi, Blueberries, Crumpets. Typing each name and one confirm is the target; read the
   hierarchy between items to see whether the keyboard and the entry field stay up.
6. **C5**: terminate, relaunch with no arguments; check the 10 new items and both C3 outcomes.
7. Stop the console capture. **C11 (runtime part only)**: warnings, faults or runtime issues from `Larder` in
   `console.log` during steps 2–6. The build and test part of C11 is scored by the lead from the build; write
   "runtime part only" in that row.
8. **C7** and **C9** from the hierarchy of the first screen, the search screen and the entry screen.
9. **C6**: `content_size accessibility-extra-extra-extra-large`, relaunch with `-LarderSeed`, look at the C2 and C4
   screens; then set it back to `large`.
10. **C8**: `appearance dark`, relaunch with `-LarderSeed`, C2 screen; then set it back to `light`.
11. **C10**: three cold launches with `-LarderSeed` (terminate before each), time to first content each, by one
    method: `xcrun xctrace record --template "App Launch"` if it works, otherwise launch-to-first-screenshot-with-rows
    timing; name the method and the three numbers. Hangs or stalls seen in steps 2–6 count too.
12. **C12** from `NOTES.md` and what you saw the app do in steps 2–10.
13. Terminate the app, `simctl uninstall` it, check appearance is light and text size is `large`.

## Output

`LABEL/SCORES.md`: a table with one row per check C1–C12: score (**Met**, **Partial**, **Not met** or
**Unscored**), the evidence in one or two lines (what the hierarchy or screenshot showed, counts, times), and the
evidence file names. Put screenshots and hierarchy dumps in `LABEL/evidence/`, named by check (`C2-first.png`,
`C4-hierarchy.txt`, …). Score strictly against the "Met when" column; Partial means some but not all of it. Do not
compare with any other app, do not guess what the builder intended, and do not suggest fixes. End with one line:
`Assessor finished at <time>, <n> of 12 scored.`
