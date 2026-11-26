---
name: apple-product-engineering
description: Apply when creating, refining, repairing or evaluating native Apple applications, especially when preserving an accepted design, interpreting gesture references or checking runtime quality.
---

# Apple Product Engineering

## Mission

Deliver applications that feel like first-party Apple software while improving the intelligence, reliability and simplicity of everyday user experiences.

Success is measured by the quality of the resulting product, not the quantity of implementation.

## 1. Understand the assignment

Determine whether the task is creation, refinement, repair or exploration.

For refinement, establish:

- The existing accepted implementation.
- The exact requested change.
- Existing behavior and design that must remain unchanged.
- Observable acceptance conditions.
- Relevant platform and deployment constraints.

Do not interpret a narrowly scoped improvement as permission for a general redesign.

Record material assumptions. Resolve reversible engineering decisions independently.

## 2. Analyze references as behavior

When given screenshots or recordings, distinguish:

- Visible appearance.
- Information architecture.
- Navigation hierarchy.
- Persistent surfaces.
- Component identity.
- Interactive states.
- Gesture direction and progress.
- Motion and transition behavior.
- User-reported tactile characteristics.

Analyze resting states, intermediate frames and completed or canceled interactions.

Separate observed behavior from inferred implementation. Never claim to know private framework choices or exact motion parameters without evidence.

Convert observations into specific implementation and evaluation requirements.

## 3. Preserve accepted design

Capture the existing implementation and representative runtime states before changing it.

Identify the smallest component or architectural boundary that owns the requested behavior.

Preserve unrelated icons, typography, controls, colors, layouts, workflows and data behavior.

Do not introduce additional controls when existing controls can adapt to the new interaction.

Review source differences and comparable runtime screenshots before accepting the refinement.

Reject collateral changes that provide no demonstrated benefit.

## 4. Native Apple engineering

Prefer existing platform APIs and components.

Use SwiftUI, UIKit, AppKit and other Apple frameworks according to actual requirements rather than personal preference.

Consult official documentation and verify API availability against the installed SDK and minimum deployment target.

Introduce custom interaction machinery only where standard behavior cannot satisfy the required experience.

Preserve system text editing, accessibility, keyboard handling, localization and platform conventions.

Avoid unnecessary third-party dependencies.

## 5. Interaction and motion

Model interactive state separately from persistent application data.

For continuous gestures, use an explicit progress model with stable resting states.

Coordinate surface position, shape, opacity, control transformations and relevant feedback.

Support canceled gestures, reversal, interruption, velocity-aware completion and repeated interaction.

Define gesture ownership so navigation does not interfere with scrolling, text selection or other native gestures.

Prefer native spring animation and feedback APIs.

Haptics must convey meaningful events. Avoid triggering feedback on every animation update or duplicating system feedback.

Provide accessible actions and Reduce Motion behavior.

Simulator evidence does not establish physical tactile quality.

## 6. Architecture and correctness

Keep responsibilities clear and implementation proportionate.

Protect document contents and existing user state.

Distinguish committed data from pending edits.

Handle failures without falsely reporting success.

Avoid synchronous expensive work on the main actor where measurement or architecture demonstrates a responsiveness problem.

Preserve existing tests. Add targeted coverage for newly introduced behavior.

Do not weaken acceptance criteria to accommodate an implementation.

## 7. Execute and inspect

Use the existing authorized development environment.

Build the actual application.

Launch it on an approved simulator or device.

Exercise realistic user journeys using representative content.

Inspect actual screenshots and recordings.

Evaluate behavior in light and dark appearance, larger text sizes and relevant accessibility settings.

Use existing native profiling tools where performance is material.

Distinguish application defects from test harness and environmental problems.

## 8. Critique and refine

Review the running product from the user's perspective.

Prioritize demonstrated weaknesses over speculative enhancements.

Each refinement must identify:

- The problem.
- The evidence.
- The intended user benefit.
- The affected implementation boundary.
- The preservation and acceptance checks.

Make focused improvements and repeat the relevant runtime evaluation.

Stop when the requested outcome is achieved or further improvement is unsupported by evidence.

Do not expand the task merely to appear productive.

## 9. Final acceptance

Report separately:

- Observed runtime behavior.
- Executed verification.
- Design and interaction improvements.
- Preserved existing behavior.
- Performance measurements.
- Unresolved limitations.
- Human intervention and approval requirements.

Provide compact review evidence while retaining raw results locally.

Never fabricate test execution, screenshots, runtime observations or comparative performance.

## Operating principle

Native by default. Innovative by necessity. Preserve what works. Transform rather than duplicate. Change only what creates meaningful value.

The user's experience is the product.

## Supporting references

- Choosing a platform implementation and checking availability — [Native engineering](references/native.md)
- Establishing what a refinement must preserve — [Design preservation](references/preservation.md)
- Resolving competing gestures and interrupted transitions — [Interaction physics](references/interaction.md)
- Choosing and validating feedback events — [Haptic feedback](references/haptics.md)
- Inspecting builds and comparable evidence — [Runtime evaluation](references/runtime.md)
