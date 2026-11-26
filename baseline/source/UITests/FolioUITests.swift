import XCTest

final class FolioUITests: XCTestCase {
    @MainActor func testWorkspaceInboxWritingAndRelaunch() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment["FOLIO_TEST_LIBRARY"] = UUID().uuidString
        app.launch()
        XCTAssertTrue(app.buttons["workspace.inbox"].waitForExistence(timeout: 10))
        capture(app, "workspace")
        app.buttons["workspace.inbox"].tap()
        XCTAssertTrue(app.buttons["collection.compose"].waitForExistence(timeout: 8))
        capture(app, "collection-empty")
        app.buttons["collection.compose"].tap()
        let title = app.descendants(matching: .any)["note.title"].firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 8))
        title.tap()
        title.typeText("The evening train\nObservations from the northern platform")
        let body = app.textViews["note.body"]
        body.tap()
        body.typeText("The station clock was five minutes slow.\n\nLook for the blue timetable.")
        capture(app, "note-keyboard")
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertEqual(body.value as? String, "The station clock was five minutes slow.\n\nLook for the blue timetable.")
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.buttons["collection.note"].firstMatch.waitForExistence(timeout: 8))
        capture(app, "collection-populated")
        app.terminate()
        app.launch()
        app.buttons["workspace.inbox"].tap()
        app.buttons["collection.note"].firstMatch.tap()
        XCTAssertTrue(body.waitForExistence(timeout: 8))
        XCTAssertEqual(body.value as? String, "The station clock was five minutes slow.\n\nLook for the blue timetable.")
        XCTAssertEqual(title.value as? String, "The evening train\nObservations from the northern platform")
        capture(app, "note-reopened")
    }

    @MainActor func testVisualDirections() {
        let app = XCUIApplication()
        app.launchEnvironment["FOLIO_TEST_LIBRARY"] = UUID().uuidString
        for direction in ["margin", "index", "ledger"] {
            app.launchArguments = ["-folio-study=" + direction]
            app.launch()
            XCTAssertTrue(app.buttons["workspace.inbox"].waitForExistence(timeout: 8))
            capture(app, "workspace-" + direction)
            app.terminate()
        }
    }

    @MainActor func testSpatialNavigationAndSearchInLargeCollection() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment["FOLIO_TEST_LIBRARY"] = UUID().uuidString
        app.launchEnvironment["FOLIO_TEST_COUNT"] = "600"
        app.launch()
        let inbox = app.buttons["workspace.inbox"]
        XCTAssertTrue(inbox.waitForExistence(timeout: 10))
        capture(app, "workspace")
        inbox.tap()
        let compose = app.buttons["collection.compose"]
        XCTAssertTrue(compose.waitForExistence(timeout: 8))
        capture(app, "collection-large")
        app.swipeUp(velocity: .slow)
        app.swipeUp(velocity: .slow)
        let rows = app.buttons.matching(identifier: "collection.note")
        guard let selected = rows.allElementsBoundByIndex.first(where: {
            $0.isHittable && $0.frame.midY > app.frame.height * 0.40 && $0.frame.midY < app.frame.height * 0.65
        }) else { XCTFail("No selectable note in middle of scrolled list"); return }
        let title = selected.label
        let originalY = selected.frame.midY
        let row = rows.matching(NSPredicate(format: "label == %@", title)).firstMatch
        selected.tap()
        let editor = app.textViews["note.body"]
        XCTAssertTrue(editor.waitForExistence(timeout: 8))
        capture(app, "note")
        edgeSwipe(app, end: 0.15)
        XCTAssertTrue(editor.isHittable, "A short swipe should leave the note open")
        edgeSwipe(app, end: 0.83)
        XCTAssertTrue(editor.waitForNonExistence(timeout: 8))
        XCTAssertTrue(row.isHittable)
        XCTAssertTrue(row.isSelected)
        XCTAssertEqual(row.frame.midY, originalY, accuracy: 6, "Returning from the note should retain the collection scroll position")
        edgeSwipe(app, end: 0.83)
        XCTAssertTrue(inbox.waitForExistence(timeout: 8))
        inbox.tap()
        XCTAssertTrue(compose.waitForExistence(timeout: 8))
        XCTAssertTrue(row.isHittable, "Re-entering a collection should restore its last visible section")
        let search = app.textFields["collection.search"]
        search.tap()
        search.typeText("blue lantern 219")
        search.typeText("\n")
        let result = rows.matching(NSPredicate(format: "label CONTAINS %@", "Field entry 219")).firstMatch
        XCTAssertTrue(result.waitForExistence(timeout: 8))
        XCTAssertEqual(rows.count, 1)
        capture(app, "search-result")
        result.tap()
        XCTAssertTrue(editor.waitForExistence(timeout: 8))
        XCTAssertTrue((editor.value as? String)?.contains("station 219") == true)
        editor.tap()
        editor.typeText("\nRevisit the east platform after dusk.")
        let done = app.buttons["Dismiss keyboard"]
        XCTAssertTrue(done.waitForExistence(timeout: 5))
        done.tap()
        capture(app, "note-edited")
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(result.waitForExistence(timeout: 8))
        XCTAssertEqual(search.value as? String, "blue lantern 219")
    }

    @MainActor func testCreateCollectionAndFavorite() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment["FOLIO_TEST_LIBRARY"] = UUID().uuidString
        app.launch()
        app.buttons["workspace.addFolder"].tap()
        let name = app.alerts.textFields.firstMatch
        name.tap()
        name.typeText("Field notes")
        app.alerts.buttons["Create"].tap()
        let compose = app.buttons["collection.compose"]
        XCTAssertTrue(compose.waitForExistence(timeout: 8))
        compose.tap()
        let title = app.textFields["note.title"]
        XCTAssertTrue(title.waitForExistence(timeout: 8))
        title.tap()
        title.typeText("An unfinished note")
        app.buttons["note.actions"].tap()
        app.buttons["Add to Favorites"].tap()
        app.navigationBars.buttons.firstMatch.tap()
        app.navigationBars.buttons.firstMatch.tap()
        app.buttons["workspace.favorites"].tap()
        XCTAssertTrue(app.buttons["collection.note"].firstMatch.waitForExistence(timeout: 8))
        app.terminate()
        app.launch()
        let folder = app.buttons["workspace.folder"]
        XCTAssertTrue(folder.waitForExistence(timeout: 8))
        folder.tap()
        XCTAssertTrue(app.buttons["collection.note"].firstMatch.waitForExistence(timeout: 8))
    }

    @MainActor func testWritingAppearance() throws {
        let app = XCUIApplication()
        app.launchEnvironment["FOLIO_TEST_LIBRARY"] = UUID().uuidString
        app.launch()
        XCTAssertTrue(app.buttons["workspace.inbox"].waitForExistence(timeout: 10))
        capture(app, "workspace")
        app.buttons["workspace.inbox"].tap()
        capture(app, "collection")
        app.buttons["collection.compose"].tap()
        let title = app.textFields["note.title"]
        XCTAssertTrue(title.waitForExistence(timeout: 8))
        title.tap()
        title.typeText("A map of the coast\nNotes from the lighthouse")
        let body = app.textViews["note.body"]
        body.tap()
        body.typeText("The wind dropped after noon.\n\nFollow the old stone wall back to the harbor.")
        XCTAssertTrue(app.navigationBars.buttons.firstMatch.isHittable)
        capture(app, "editor-keyboard")
        let done = app.buttons["Dismiss keyboard"]
        XCTAssertTrue(done.exists)
        done.tap()
        capture(app, "editor")
        if ProcessInfo.processInfo.environment["FOLIO_SKIP_AUDIT"] == nil {
            try app.performAccessibilityAudit(for: [.hitRegion, .sufficientElementDescription, .dynamicType]) { issue in
                print("FOLIO_AX: \(issue.auditType) \(issue.compactDescription)")
                return true
            }
        }
    }

    @MainActor private func edgeSwipe(_ app: XCUIApplication, end: CGFloat) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.005, dy: 0.52))
            .press(forDuration: 0.04,
                   thenDragTo: app.coordinate(withNormalizedOffset: CGVector(dx: end, dy: 0.52)),
                   withVelocity: .slow, thenHoldForDuration: 0.18)
    }

    @MainActor private func capture(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
