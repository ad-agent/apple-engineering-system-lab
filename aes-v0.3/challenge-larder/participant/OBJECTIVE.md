# Larder: use food before it goes off

You are working in an iOS app project called Larder. It contains Xcode's iOS App template, `larder-seed.json` (32
fictional household food items) and `RESEARCH.md` (short notes from interviews). Nothing else has been built.

**The problem.** Households throw away food because they forget what they have and when it goes off. The people
interviewed had tried list apps and stopped within a week. Adding things took too long right after shopping, when
the bags are on the counter and one hand is busy, and the apps did not tell them what to eat first.

**Objective.** Build Larder into a native iPhone app for iOS 27 that makes it quick to record what was bought and
obvious what to use soon. The primary journeys are:

1. Straight after shopping, add the ten or so things just bought, one after another.
2. Open the app and see at a glance what should be used in the next few days.
3. Mark an item as used up or thrown away, and recover from a mistaken tap.
4. In the shop, check whether something is already at home, and where.

**Reference.** `reference/quick-entry.mov` is a short screen recording of a first-party iPhone list app entering
several items in a row. Study what makes that fast. Do not copy its branding, names or artwork.

**Fixture.** When the app is launched with the argument `-LarderSeed`, it replaces its stored items with the
contents of `larder-seed.json` (bundled in the app). Dates in the file are relative to the launch day. Without the
argument, the app keeps what the user stored.

The rest is your decision as the product team: categories, how expiry dates are entered or defaulted, layout, what
the first screen shows, and whether the system can do some of the work (widgets, Siri and Shortcuts, Spotlight).
Choose what solves the users' problem, not what looks distinctive.

Build, launch, inspect, interact with, critique and refine the running app. Finish with a short `NOTES.md` in the
project root: the journeys as you defined them, your product decisions and why, and what you verified and how.

You have 30 minutes. Follow `CLAUDE.md` in this folder.
