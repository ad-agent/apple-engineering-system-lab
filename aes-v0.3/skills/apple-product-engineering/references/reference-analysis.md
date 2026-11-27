# Reading a reference as an experience

A screenshot, recording or product description says what a user should experience, not how it was built. Turn it
into journeys you can check in the running app, and into the principle that makes them good.

## Get the material

- Screenshot: note device class, orientation, appearance, text size and what is cut off.
- Recording: `ffprobe` for size, frame rate and duration. Make a contact sheet to find the moments
  (`ffmpeg -i ref.mov -vf "fps=2,scale=320:-1,tile=6x4" sheet.png`), then extract full frames around each moment
  (`ffmpeg -ss 12.4 -to 13.4 -i ref.mov -vf fps=30 f%03d.png`). For motion, measure an edge per frame
  ([examples/edge-track](../examples/edge-track/)).
- Product description: underline who the user is, the situation they are in (hurried, one-handed, offline,
  interrupted) and the outcome they want. These decide priorities when the description says nothing about layout.
- Write down what the material cannot show: touches (unless shown), haptics, sound, timing below the frame rate,
  states never visited.

## Analyse in this order

1. **Information architecture.** What content and actions exist, how they group, what is primary.
2. **Persistent surfaces and space.** Which surfaces stay on screen across states, which slide, which cover which.
3. **Component identity.** Follow each control across frames by function, label, position and order. A control that
   changes shape but keeps its role is the same control transformed (menu → close).
4. **Journeys.** For each task: starting state → user action → resulting state, with the number of taps and
   screens. The resulting state is the expected end state you will check in your app.
5. **Gesture progression.** Contact, first movement, how far content follows the finger, reversal, release, settle,
   overshoot. Mark frame numbers.
6. **Motion coordination.** Which properties move together, which lead or lag, what changes at a threshold.
7. **State continuity.** What is kept across a transition: scroll position, search text, selection, keyboard, the
   place on the map. What returns to where it was when the user backs out.
8. **Reported feel.** What the person says about haptics or weight, recorded as their report.
9. **The usability principle.** Why the user is better off: context stays in view, the way back is the way in, the
   common action is one step, nothing typed is lost. Name it per journey. It decides what must be kept when the
   reference conflicts with the platform or the existing app, and it is what you test, not the pixels.

## Record three columns

| Observed (frame or pixel evidence) | Inferred (stated as such) | Unknown |
|---|---|---|
| "At 22.36 s about 70 pt of the main surface stays visible at the trailing edge" | "Probably a pan, because content moved from the first frame of contact" | Haptic timing; spring parameters; framework |

Do not assign spring constants, frameworks or private implementation to the reference. Say "settles in about 0.4 s
without visible overshoot", not "uses a spring with damping 0.8".

## Turn it into journeys and requirements

Write each primary journey as a check you can run, with its end state from the reference:

| Journey | Starting state | Action | Expected end state | Principle |
|---|---|---|---|---|
| Cancel search | sheet at smallest height, map shows all places | tap search, type, tap Cancel | sheet at smallest height; all places shown; text cleared | the way back is the way in |

Add the neighbouring requirements ("a drag reversed before release returns without a jump", "the search text survives
closing the sheet"). Keep the principle, adapt the form: if the reference has two close buttons and the brief asks
for one, one wins. Then check each requirement against native.md before choosing an implementation, and look for the
opportunities in product.md.
