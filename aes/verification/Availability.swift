import SwiftUI
import UIKit

struct FeedbackProbe: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    var selected: Bool

    var body: some View {
        let label = Text(selected ? "Selected" : "Available")
            .animation(reduceMotion ? nil : .interactiveSpring(), value: selected)
        if #available(iOS 17, *) {
            label.sensoryFeedback(.selection, trigger: selected)
        } else {
            label
        }
    }
}

@MainActor
func sample(_ pan: UIPanGestureRecognizer, in parent: UIView) -> (CGPoint, CGPoint) {
    (pan.translation(in: parent), pan.velocity(in: parent))
}
