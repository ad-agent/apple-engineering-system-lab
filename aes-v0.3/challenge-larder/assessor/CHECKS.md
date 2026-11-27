# Larder — assessor checks (never shown to participants)

Written by the lead on 2026-11-27, before any participant run. Each check is scored **Met / Partial / Not met** with
evidence from the running app (hierarchy, screenshot, recording, log), on `iPhone 18 Pro Max`, after launching with
`-LarderSeed`. Run them by one script, unchanged for every arm (RECOMMENDATIONS.md "For the next trial"), on a quiet
Mac with the load average recorded. The assessor sees the app under its coin-flip label only.

## Journeys (starting state → action → expected end state)

| # | Check | Starting state | Action | Met when |
|---|---|---|---|---|
| C1 | Burst entry | seeded app, first screen | add 10 named items in a row | each new item needs only its name typed and one confirm; the keyboard stays up between items; no screen change or sheet dismissal between items; all 10 appear with an expiry (defaulted or entered) |
| C2 | Use soon at a glance | seeded app, cold launch | none | the first screen leads with the items expiring within 3 days (seed: 12 items, including Hummus and Coriander already past), ordered by expiry, with human dates ("tomorrow", "in 2 days"); the soonest are visible without scrolling at default size |
| C3 | Used or binned, and undo | seeded app | mark "Baby spinach" used; mark "Hummus" thrown away; undo the last | both actions take at most two touches with no confirmation dialog; undo (shake, button or toast) restores Hummus with its expiry; used and thrown away are recorded differently |
| C4 | Already at home? | seeded app, from the first screen | search "egg" | "Eggs (12)" found within two touches plus typing, showing its location (Fridge) |
| C5 | Survives relaunch | after C1 and C3, no seed argument | terminate and relaunch | the 10 new items and both C3 outcomes are still there |

## Every user

| # | Check | Met when |
|---|---|---|
| C6 | Largest text size | at `accessibility-extra-extra-extra-large`, C2 and C4 screens show item names and dates without truncation to meaningless fragments, no overlap, controls still reachable |
| C7 | VoiceOver | in the hierarchy, each row reads name and expiry in words; every button has a word label (no symbol names, no placeholder-only field); every swipe action also exists as an accessibility action or visible control |
| C8 | Dark appearance | C2 screen in dark: no hard-coded light colours, expiry emphasis still legible |

## Native quality and engineering

| # | Check | Met when |
|---|---|---|
| C9 | Native components | system list, search, swipe actions or context menu, toolbar; no hand-drawn chrome replacing a system control |
| C10 | Responsiveness | median of 3 cold launches to first content under 1.5 s on a quiet Mac; no XCTest stalls or hangs during C1–C5 |
| C11 | Clean run | the project builds without warnings that the participant introduced; its tests pass; no runtime warnings in the console during C1–C5 |
| C12 | Product decisions | NOTES.md names the journeys with end states and at least one decision that removes a user cost from RESEARCH.md (for example category-based expiry defaults, "use soon" first, a widget or Shortcut), and the app actually does it |

## Not scored

Feel, animation quality and haptics (no physical device in this trial); visual taste beyond C8–C9.
