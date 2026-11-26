# Reading a reference as an experience

A screenshot or recording describes what a user experiences, not how it was built. Turn it into requirements you can
check in the running app.

## Get the material

- Screenshot: note device class, orientation, appearance, text size and what is cut off.
- Recording: `ffprobe` for size, frame rate and duration. Make a contact sheet to find the moments
  (`ffmpeg -i ref.mov -vf "fps=2,scale=320:-1,tile=6x4" sheet.png`), then extract full frames around each moment
  (`ffmpeg -ss 12.4 -to 13.4 -i ref.mov -vf fps=30 f%03d.png`). Look at the frames; for motion, measure an edge
  per frame ([examples/edge-track](../examples/edge-track/)).
- Write down what the recording cannot show: touches (unless shown), haptics, sound, timing below its frame rate.

## Analyse in this order

1. **Information architecture.** What content and actions exist, how they group, what is primary.
2. **Persistent surfaces and space.** Which surfaces stay on screen across states, which slide, which cover which;
   where each sits relative to the others (left of, under, inset by ~N pt).
3. **Component identity.** Follow each control across frames by function, label, position and order. A control that
   changes shape or symbol but keeps its role is the same control transformed (menu → close). Two similar shapes are
   not enough to claim identity.
4. **Journeys.** The steps a user takes for each task, with the number of taps and screens.
5. **Gesture progression.** Contact (if visible), first movement, how far content follows the finger, reversal,
   release, settle, overshoot. Mark frame numbers.
6. **Motion coordination.** Which properties move together (position, corner radius, opacity, symbol), which lead
   or lag, and whether anything changes at a threshold rather than continuously.
7. **State continuity.** What is visibly kept across the transition: scroll position, search text, selection,
   keyboard.
8. **Reported feel.** What the person says about haptics or weight. Record it as their report.
9. **The benefit.** Why a user is better off: fewer steps, context kept in view, faster return. This decides what
   must be kept when the reference conflicts with the platform or the existing app.

## Record three columns

| Observed (frame or pixel evidence) | Inferred (reasoning, stated as such) | Unknown |
|---|---|---|
| "At 22.36 s about 70 pt of the main surface stays visible at the trailing edge" | "Probably a pan rather than an edge swipe, because content moved from the first frame of contact" | Haptic timing; spring parameters; framework used |

Do not assign spring constants, framework choices or private implementation to the reference. Say "settles in about
0.4 s without visible overshoot", not "uses a spring with damping 0.8".

## Turn it into requirements

Each requirement is observable in your app: "after opening, the main surface's leading edge rests 60–80 pt from the
trailing screen edge", "a drag that is reversed before release returns the surface without a jump", "the search
text is unchanged after closing". Keep the benefit, adapt the form: if the reference has two close buttons and the
brief asks for one, one wins. Then check each requirement against native.md before choosing an implementation.
