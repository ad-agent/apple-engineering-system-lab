import SwiftUI
import UIKit

/// Interactive state of the workspace reveal, kept apart from library data.
/// Progress 0 rests the collection surface over the workspace; 1 leaves a sliver of it beside the workspace.
@MainActor @Observable
final class WorkspaceReveal {
    static let duration = 0.42
    /// Seconds of finger velocity carried forward when deciding where a released drag settles.
    static let carry = 0.18

    var progress: Double {
        didSet { if (progress > 0.5) != showsClose { showsClose.toggle() } }
    }
    /// Changes only when the surface crosses halfway, so the controls that follow it do not redraw every frame.
    private(set) var showsClose: Bool
    private(set) var isRevealed: Bool
    private(set) var isDragging = false
    @ObservationIgnored private var base = 0.0
    @ObservationIgnored private var settling: (start: Date, from: Double, to: Double, velocity: Double)?

    init(revealed: Bool) {
        isRevealed = revealed
        showsClose = revealed
        progress = revealed ? 1 : 0
    }

    /// The workspace reads at full width on iPhone; the surface keeps a sliver for the close and search controls.
    static func distance(for width: Double) -> Double { min(width * 0.82, 380) }

    /// Where the settling spring has carried the surface by `date`, so an interrupting drag picks it up in place.
    func presentation(at date: Date) -> Double {
        guard let settling else { return isRevealed ? 1 : 0 }
        // Matches the critically damped spring used to settle: stiffness (2π / duration)², bounce 0.
        let omega = 2 * Double.pi / Self.duration
        let time = max(0, date.timeIntervalSince(settling.start))
        let offset = settling.from - settling.to
        return settling.to + (offset + (settling.velocity + omega * offset) * time) * exp(-omega * time)
    }

    func beginDrag(at date: Date = .now) {
        base = presentation(at: date)
        settling = nil
        isDragging = true
        progress = base
    }

    func drag(_ translation: Double, distance: Double) {
        let raw = base + translation / max(distance, 1)
        progress = raw > 1 ? 1 + (raw - 1) * 0.2 : max(0, raw)
    }

    /// The resting state a released drag commits to, after carrying its velocity forward.
    func target(releasing velocity: Double, distance: Double) -> Bool {
        progress + velocity / max(distance, 1) * Self.carry > 0.5
    }

    /// Commits to a resting state and returns the spring's initial velocity relative to the remaining distance.
    func settle(revealed: Bool, velocity: Double = 0, at date: Date = .now) -> Double {
        let from = isDragging ? progress : presentation(at: date)
        let to: Double = revealed ? 1 : 0
        isDragging = false
        isRevealed = revealed
        settling = (date, from, to, velocity)
        return abs(to - from) < 0.001 ? 0 : velocity / (to - from)
    }
}

/// A horizontal pan that owns the reveal only once it is clearly sideways and in the direction that can move the surface,
/// so vertical scrolling, row taps and the navigation back swipe keep their native behavior.
@available(iOS 18, *)
struct WorkspaceRevealPan: UIGestureRecognizerRepresentable {
    let isEnabled: Bool
    let isRevealed: Bool
    let began: () -> Void
    let changed: (Double) -> Void
    let ended: (Double) -> Void
    let cancelled: () -> Void

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator { Coordinator() }

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        pan.delegate = context.coordinator
        pan.maximumNumberOfTouches = 1
        return pan
    }

    func updateUIGestureRecognizer(_ pan: UIPanGestureRecognizer, context: Context) {
        pan.isEnabled = isEnabled
        context.coordinator.isRevealed = isRevealed
    }

    func handleUIGestureRecognizerAction(_ pan: UIPanGestureRecognizer, context: Context) {
        switch pan.state {
        case .began: began()
        case .changed: changed(pan.translation(in: nil).x)
        case .ended: ended(pan.velocity(in: nil).x)
        case .cancelled, .failed: cancelled()
        default: break
        }
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var isRevealed = false

        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            guard let pan = recognizer as? UIPanGestureRecognizer else { return false }
            let velocity = pan.velocity(in: nil)
            return abs(velocity.x) > abs(velocity.y) * 1.2 && (isRevealed ? velocity.x < 0 : velocity.x > 0)
        }

        func gestureRecognizer(_ recognizer: UIGestureRecognizer,
                               shouldBeRequiredToFailBy other: UIGestureRecognizer) -> Bool {
            // Scrolling waits only for the sideways decision, which the pan makes within its first few points.
            guard let scrollView = other.view as? UIScrollView else { return false }
            return other === scrollView.panGestureRecognizer
        }
    }
}

/// Slides the collection surface aside as one rounded card, leaving the workspace still beneath it.
struct RevealedSurface: ViewModifier {
    let reveal: WorkspaceReveal
    let distance: Double
    let paper: Color

    func body(content: Content) -> some View {
        let progress = reveal.progress
        let amount = min(max(progress, 0), 1)
        let shape = RoundedRectangle(cornerRadius: 44 * amount, style: .continuous)
        content
            .clipShape(shape)
            .overlay {
                shape.strokeBorder(Color.primary.opacity(0.1 * amount), lineWidth: 1).allowsHitTesting(false)
            }
            .background {
                shape.fill(paper).shadow(color: .black.opacity(0.16 * amount), radius: 22)
            }
            .offset(x: progress * distance)
    }
}

