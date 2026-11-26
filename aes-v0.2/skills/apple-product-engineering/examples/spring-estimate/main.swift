// Spring estimate check (AES v0.2 example).
//
// Question: an app that hand-computes where a SwiftUI spring "is" (to let a drag grab a moving surface)
// relies on three assumptions. Which hold, and by how much does each failure move the surface?
//
// Run (macOS, Xcode 27 toolchain):  swift main.swift
// This checks SwiftUI's own Spring model only. It cannot show what was rendered: frame timing, the
// animation's real start time and SwiftUI's merging of in-flight animations still need a recording.
import Foundation
import SwiftUI

let duration = 0.42          // Experimental B: .interpolatingSpring(duration: 0.42, bounce: 0, initialVelocity:)
let distance = 360.0         // points travelled from progress 0 to 1 on the trial phone
let omega = 2 * Double.pi / duration

// B's closed form for a critically damped spring, in progress units, displacement x0 from the target.
func analytic(x0: Double, v0: Double, t: Double) -> Double { (x0 + (v0 + omega * x0) * t) * exp(-omega * t) }

let spring = Spring(duration: duration, bounce: 0)
print(String(format: "1. Spring(duration: 0.42, bounce: 0): mass %.3f stiffness %.2f damping %.2f; (2π/d)² = %.2f, 2ω = %.2f",
             spring.mass, spring.stiffness, spring.damping, omega * omega, 2 * omega))

// Assumption 1: the closed form equals SwiftUI's spring for the same start, target and velocity.
var worst1 = 0.0
for v0 in [-4.0, 0.0, 3.0] {
    for step in 0...60 {
        let t = Double(step) / 120
        // Spring.value moves from 0 toward `target`; express B's displacement x0 = from - to = -1.
        let swiftUI = spring.value(target: 1.0, initialVelocity: v0, time: t) - 1.0
        worst1 = max(worst1, abs(swiftUI - analytic(x0: -1, v0: v0, t: t)))
    }
}
print(String(format: "   max |closed form - Spring.value| over 0.5 s = %.2e progress (%.4f pt)", worst1, worst1 * distance))

// Assumption 2: Reduce Motion uses the same curve. B animates .easeOut(duration: 0.2) there, but still estimates a spring.
var worst2 = (gap: 0.0, t: 0.0)
for step in 0...60 {
    let t = Double(step) / 120
    let eased = 1 - UnitCurve.easeOut.value(at: min(t / 0.2, 1))   // remaining displacement, 1 → 0
    let estimate = -analytic(x0: -1, v0: 0, t: t)
    let gap = abs(eased - estimate)
    if gap > worst2.gap { worst2 = (gap, t) }
}
print(String(format: "2. Reduce Motion: easeOut(0.2) vs spring estimate, worst gap %.3f progress = %.0f pt at t = %.3f s",
             worst2.gap, worst2.gap * distance, worst2.t))

// Assumption 3: when a control tap re-targets a settle in flight, the new settle starts at rest.
// B passes velocity 0 for control taps. The iOS 27.2 SDK documents interpolatingSpring as "Preserves velocity across
// overlapping animations by adding the effects of each animation". The sum is not modelled here; this bounds the
// error of assuming a fresh spring at rest against the simplest velocity-keeping alternative.
let tapAt = 0.08                                      // user taps X 80 ms into an opening settle from 0 → 1
let x0 = analytic(x0: -1, v0: 0, t: tapAt)            // displacement from 1 at the tap
let h = 1e-4
let vAtTap = (analytic(x0: -1, v0: 0, t: tapAt + h) - analytic(x0: -1, v0: 0, t: tapAt - h)) / (2 * h)
let position = 1 + x0                                 // progress when the reversal begins
var worst3 = (gap: 0.0, t: 0.0)
for step in 0...60 {
    let t = Double(step) / 120
    // Both models now settle toward 0 from `position`. One keeps the opening velocity, the other starts at rest.
    let kept = analytic(x0: position, v0: vAtTap, t: t)
    let zeroed = analytic(x0: position, v0: 0, t: t)
    let gap = abs(kept - zeroed)
    if gap > worst3.gap { worst3 = (gap, t) }
}
print(String(format: "3. Re-targeted settle (tap at %.0f ms, progress %.2f, velocity %.2f/s): velocity-kept vs zeroed differ by up to %.3f progress = %.0f pt at t = %.3f s",
             tapAt * 1000, position, vAtTap, worst3.gap, worst3.gap * distance, worst3.t))

// Clock offset: the estimate starts at Date() inside the call; the animation starts at the next committed frame.
for frames in [1.0, 2.0, 6.0] {
    let lag = frames / 120
    var worst = 0.0
    for step in 0...60 {
        let t = Double(step) / 120
        worst = max(worst, abs(analytic(x0: -1, v0: 0, t: t) - analytic(x0: -1, v0: 0, t: max(0, t - lag))))
    }
    print(String(format: "4. Start-time error of %.0f frame(s) at 120 Hz: up to %.3f progress = %.1f pt", frames, worst, worst * distance))
}
