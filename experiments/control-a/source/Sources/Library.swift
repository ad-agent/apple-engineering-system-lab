import Foundation
import Observation

struct Folder: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct Note: Codable, Identifiable {
    var id = UUID()
    var folder: UUID?
    var title = ""
    var body = ""
    var favorite = false
    var modified = Date()
    var displayTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : title
    }
}

struct Library: Codable {
    var folders: [Folder] = []
    var notes: [Note] = []
}

enum Shelf: Hashable {
    case inbox, favorites, recent, folder(UUID)

    func includes(_ note: Note) -> Bool {
        switch self {
        case .inbox: note.folder == nil
        case .favorites: note.favorite
        case .recent: true
        case .folder(let id): note.folder == id
        }
    }

    var folderID: UUID? {
        if case .folder(let id) = self { return id }
        return nil
    }
}

enum Route: Hashable { case shelf(Shelf), note(UUID, composing: Bool = false) }

@MainActor @Observable
final class NoteStore {
    private(set) var library = Library()
    private(set) var loadFailure: String?
    private(set) var writeFailure: String?
    @ObservationIgnored private var dirty = false
    @ObservationIgnored private var pending: Task<Void, Never>?
    private let url: URL

    init(url: URL) {
        self.url = url
        reload()
    }

    func reload() {
        guard !dirty else { return }
        do {
            let candidate = try JSONDecoder().decode(Library.self, from: Data(contentsOf: url))
            guard Set(candidate.folders.map(\.id)).count == candidate.folders.count,
                  Set(candidate.notes.map(\.id)).count == candidate.notes.count else {
                throw CocoaError(.fileReadCorruptFile)
            }
            library = candidate
            loadFailure = nil
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            library = Library()
            loadFailure = nil
        } catch {
            loadFailure = "Folio couldn’t read your library. Try opening it again."
        }
    }

    func title(_ shelf: Shelf) -> String {
        switch shelf {
        case .inbox: "Inbox"
        case .favorites: "Favorites"
        case .recent: "Recent"
        case .folder(let id): library.folders.first { $0.id == id }?.name ?? "Collection"
        }
    }

    func notes(in shelf: Shelf, matching query: String = "") -> [Note] {
        let terms = query.split(whereSeparator: \.isWhitespace).map(String.init)
        return library.notes.filter { note in
            shelf.includes(note) && terms.allSatisfy {
                note.title.localizedStandardContains($0) ||
                note.body.localizedStandardContains($0)
            }
        }.sorted { $0.modified > $1.modified }
    }

    func note(_ id: UUID) -> Note? { library.notes.first { $0.id == id } }

    func create(in shelf: Shelf) -> UUID? {
        guard loadFailure == nil else { return nil }
        let note = Note(folder: shelf.folderID, favorite: shelf == .favorites)
        library.notes.append(note)
        dirty = true
        flush()
        return note.id
    }

    func addFolder(_ name: String) -> UUID? {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, loadFailure == nil else { return nil }
        let folder = Folder(name: name)
        library.folders.append(folder)
        dirty = true
        flush()
        return folder.id
    }

    func edit<Value: Equatable>(_ id: UUID, _ field: WritableKeyPath<Note, Value>, _ value: Value) {
        guard let index = library.notes.firstIndex(where: { $0.id == id }),
              library.notes[index][keyPath: field] != value else { return }
        library.notes[index][keyPath: field] = value
        library.notes[index].modified = Date()
        dirty = true
        pending?.cancel()
        pending = Task { [weak self] in
            do { try await Task.sleep(for: .milliseconds(280)) } catch { return }
            self?.flush()
        }
    }

    func delete(_ id: UUID) {
        library.notes.removeAll { $0.id == id }
        dirty = true
        flush()
    }

    func flush() {
        pending?.cancel()
        pending = nil
        guard dirty else { return }
        do {
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try JSONEncoder().encode(library).write(to: url, options: .atomic)
            dirty = false
            writeFailure = nil
        } catch {
            writeFailure = "Changes are still open in Folio. Retry to save them."
        }
    }
}
