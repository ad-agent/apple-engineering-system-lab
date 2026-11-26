import XCTest
@testable import Folio

final class WorkspaceRevealTests: XCTestCase {
    private let distance = 360.0

    @MainActor func testSlowDragCommitsPastHalfwayAndCancelsShortOfIt() {
        let reveal = WorkspaceReveal(revealed: false)
        reveal.beginDrag()
        reveal.drag(distance * 0.4, distance: distance)
        XCTAssertEqual(reveal.progress, 0.4, accuracy: 0.001)
        XCTAssertFalse(reveal.target(releasing: 0, distance: distance))
        reveal.drag(distance * 0.62, distance: distance)
        XCTAssertTrue(reveal.target(releasing: 0, distance: distance))
        _ = reveal.settle(revealed: true)
        XCTAssertTrue(reveal.isRevealed)
        XCTAssertFalse(reveal.isDragging)
    }

    @MainActor func testVelocityDecidesAShortFlickAndAReversal() {
        let reveal = WorkspaceReveal(revealed: false)
        reveal.beginDrag()
        reveal.drag(distance * 0.2, distance: distance)
        XCTAssertTrue(reveal.target(releasing: 1_400, distance: distance), "A quick flick opens from a short drag")
        reveal.drag(distance * 0.7, distance: distance)
        XCTAssertFalse(reveal.target(releasing: -1_400, distance: distance), "Reversing quickly returns the surface")
    }

    @MainActor func testDragResistsBeyondRevealAndStopsAtRest() {
        let reveal = WorkspaceReveal(revealed: true)
        reveal.beginDrag()
        reveal.drag(distance, distance: distance)
        XCTAssertEqual(reveal.progress, 1.2, accuracy: 0.001)
        reveal.drag(-distance * 2, distance: distance)
        XCTAssertEqual(reveal.progress, 0)
    }

    @MainActor func testInterruptingASettleContinuesFromThePresentedPosition() {
        let reveal = WorkspaceReveal(revealed: true)
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let velocity = reveal.settle(revealed: false, at: start)
        XCTAssertEqual(velocity, 0)
        let early = reveal.presentation(at: start.addingTimeInterval(0.05))
        let later = reveal.presentation(at: start.addingTimeInterval(0.15))
        XCTAssertGreaterThan(early, later)
        XCTAssertTrue((0.0...1.0).contains(later) && later > 0.05, "Mid-settle the surface is still on its way")
        XCTAssertEqual(reveal.presentation(at: start.addingTimeInterval(2)), 0, accuracy: 0.001)
        reveal.beginDrag(at: start.addingTimeInterval(0.15))
        XCTAssertEqual(reveal.progress, later, accuracy: 0.0001)
        reveal.drag(0, distance: distance)
        XCTAssertEqual(reveal.progress, later, accuracy: 0.0001, "Grabbing the surface does not make it jump")
    }

    @MainActor func testCancelledDragReturnsToTheCommittedState() {
        let reveal = WorkspaceReveal(revealed: true)
        reveal.beginDrag()
        reveal.drag(-distance * 0.3, distance: distance)
        let velocity = reveal.settle(revealed: reveal.isRevealed)
        XCTAssertTrue(reveal.isRevealed)
        XCTAssertEqual(velocity, 0)
    }

    @MainActor func testDistanceLeavesASliverOnPhonesAndCapsOnWideScreens() {
        XCTAssertEqual(WorkspaceReveal.distance(for: 440), 360.8, accuracy: 0.01)
        XCTAssertEqual(WorkspaceReveal.distance(for: 1_024), 380)
    }
}
