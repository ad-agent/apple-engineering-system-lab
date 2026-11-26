import XCTest
@testable import Folio

final class NoteStoreTests: XCTestCase {
    @MainActor func testUnfinishedNoteSaveAndExactRelaunch() async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: url) }
        let store = NoteStore(url: url)
        let folder = try XCTUnwrap(store.addFolder("Field notes"))
        let id = try XCTUnwrap(store.create(in: .folder(folder)))
        let title = " Platform two\nThe late train "
        let body = "  A note with café, 🫖 and a decomposed e\u{301}.\n\n"
        store.edit(id, \.title, title)
        store.edit(id, \.body, body)
        try await Task.sleep(for: .milliseconds(450))
        let reopened = NoteStore(url: url)
        XCTAssertEqual(reopened.note(id)?.title, title)
        XCTAssertEqual(reopened.note(id)?.body, body)
        XCTAssertEqual(reopened.note(id)?.folder, folder)
        XCTAssertEqual(reopened.notes(in: .folder(folder), matching: "cafe train").map(\.id), [id])
    }

    @MainActor func testCommitFailureRetriesWithoutDiscardingOpenEdit() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("Library.json")
        let store = NoteStore(url: url)
        let id = try XCTUnwrap(store.create(in: .inbox))
        let committed = try Data(contentsOf: url)
        let backup = directory.appendingPathComponent("Previous.json")
        try FileManager.default.moveItem(at: url, to: backup)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        store.edit(id, \.body, "Kept in the editor")
        store.flush()
        XCTAssertNotNil(store.writeFailure)
        XCTAssertEqual(store.note(id)?.body, "Kept in the editor")
        XCTAssertEqual(try Data(contentsOf: backup), committed)
        try FileManager.default.removeItem(at: url)
        try FileManager.default.moveItem(at: backup, to: url)
        store.flush()
        XCTAssertNil(store.writeFailure)
        XCTAssertEqual(NoteStore(url: url).note(id)?.body, "Kept in the editor")
    }

    @MainActor func testUnreadableLibraryIsProtectedUntilReload() async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: url) }
        let corrupt = Data("invalid JSON".utf8)
        try corrupt.write(to: url)
        let store = NoteStore(url: url)
        XCTAssertNotNil(store.loadFailure)
        XCTAssertNil(store.create(in: .inbox))
        XCTAssertEqual(try Data(contentsOf: url), corrupt)
        try JSONEncoder().encode(Library()).write(to: url, options: .atomic)
        store.reload()
        XCTAssertNil(store.loadFailure)
    }

    @MainActor func testMeasuredLargeLibrarySearch() async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: url) }
        let folder = Folder(name: "Field notes")
        let notes = (0..<4000).map { number in
            Note(folder: folder.id, title: "Entry \(number)",
                 body: "Measurements of the shoreline and station \(number).",
                 modified: Date(timeIntervalSince1970: Double(number)))
        }
        try JSONEncoder().encode(Library(folders: [folder], notes: notes)).write(to: url)
        let store = NoteStore(url: url)
        XCTAssertEqual(store.notes(in: .folder(folder.id), matching: "shoreline 3999").count, 1)
        measure(metrics: [XCTClockMetric()]) {
            for _ in 0..<10 {
                _ = store.notes(in: .folder(folder.id), matching: "shoreline 3999")
            }
        }
    }
}
