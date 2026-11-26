# Haptic feedback

First exercise the unmodified system control on supported hardware. If it already signals the event, retain that behavior. For a custom selection, tie feedback to an actual change of selected value. For a save confirmation, signal success only after the write succeeds. Keep visual or spoken confirmation available independently.

On supported SwiftUI targets, sensoryFeedback can observe an Equatable trigger. Use a committed selection or event identity. Driving the trigger with drag distance can replay feedback on every update. When previewing a threshold, latch the crossing and define when reversal rearms it. Test cancellation, a repeated identical action and a failed action.

Record device model, OS, feedback settings and the event the reviewer actually felt. Simulator traces can establish event ordering. A physical-device review establishes perceived timing and strength.

[Apple SensoryFeedback](https://developer.apple.com/documentation/swiftui/sensoryfeedback)
