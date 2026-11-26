import SwiftUI

private enum Direction: String {
    case margin, index, ledger
    var serif: Font.Design { self == .index ? .default : .serif }
    var accent: Color {
        switch self {
        case .margin: Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.58, green: 0.79, blue: 0.73, alpha: 1)
                : UIColor(red: 0.13, green: 0.37, blue: 0.32, alpha: 1)
        })
        case .index: .indigo
        case .ledger: .brown
        }
    }
    var paper: Color {
        Color(uiColor: UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return self == .index ? .black : UIColor(white: 0.09, alpha: 1)
            }
            switch self {
            case .margin: return UIColor(red: 0.98, green: 0.97, blue: 0.94, alpha: 1)
            case .ledger: return UIColor(red: 0.96, green: 0.93, blue: 0.89, alpha: 1)
            case .index: return .white
            }
        })
    }
}

private extension View {
    @ViewBuilder func folioListStyle(_ direction: Direction) -> some View {
        if direction == .index { listStyle(.insetGrouped) }
        else { listStyle(.plain) }
    }
}

@main struct FolioApp: App {
    @Environment(\.scenePhase) private var phase
    @State private var store: NoteStore
    private let direction: Direction

    init() {
        #if DEBUG
        let prototype = ProcessInfo.processInfo.arguments
            .first { $0.hasPrefix("-folio-study=") }?.split(separator: "=").last
        direction = prototype.flatMap { Direction(rawValue: String($0)) } ?? .margin
        #else
        direction = .margin
        #endif
        let folder = URL.applicationSupportDirectory.appending(path: "Folio", directoryHint: .isDirectory)
        var url = folder.appending(path: "Library.json")
        #if DEBUG
        let environment = ProcessInfo.processInfo.environment
        if let name = environment["FOLIO_TEST_LIBRARY"], let tag = UUID(uuidString: name) {
            url = folder.appending(path: tag.uuidString + ".json")
            if let count = environment["FOLIO_TEST_COUNT"].flatMap(Int.init),
               (1...1_000).contains(count), !FileManager.default.fileExists(atPath: url.path) {
                let samples = (0..<count).map { number in
                    Note(title: "Field entry \(number)",
                         body: "Catalogued the blue lantern at station \(number).",
                         modified: Date(timeIntervalSince1970: Double(number)))
                }
                do {
                    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
                    try JSONEncoder().encode(Library(notes: samples)).write(to: url, options: .atomic)
                } catch {
                    assertionFailure("Could not prepare UI test library: \(error)")
                }
            }
        }
        #endif
        _store = State(initialValue: NoteStore(url: url))
    }

    var body: some Scene {
        WindowGroup {
            Workspace(store: store, direction: direction)
                .tint(direction.accent)
                .onChange(of: phase) { _, phase in
                    if phase != .active { store.flush() }
                }
        }
    }
}

private struct CollectionMemory {
    var query = ""
    var anchor: UUID?
    var selectedNote: UUID?
}

private struct EditorMemory {
    var title: NSRange?
    var body: NSRange?
}

private struct Workspace: View {
    let store: NoteStore
    let direction: Direction
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var path: [Route] = []
    @State private var shelf: Shelf = .inbox
    @State private var lastShelf: Shelf?
    @State private var memories: [Shelf: CollectionMemory] = [:]
    @State private var selections: [UUID: EditorMemory] = [:]
    @State private var reveal = WorkspaceReveal(revealed: true)
    /// The workspace leaves the hierarchy, and so the accessibility tree, once the surface has settled over it.
    @State private var workspaceShown = true
    @State private var committedDrags = 0
    @ScaledMetric(relativeTo: .body) private var shelfIconWidth = 28.0
    @State private var newFolder = false
    @State private var folderName = ""

    var body: some View {
        GeometryReader { proxy in
            let distance = WorkspaceReveal.distance(for: proxy.size.width)
            ZStack(alignment: .topLeading) {
                if workspaceShown {
                    workspace
                        .frame(width: distance)
                        .accessibilityAction(.escape) { settle(revealed: false) }
                }
                surface
                    .modifier(RevealedSurface(reveal: reveal, distance: distance, paper: direction.paper))
            }
            .modifier(RevealGesture(enabled: path.isEmpty, reveal: reveal, distance: distance,
                                    settle: settle(revealed:velocity:)) { committedDrags += 1 })
        }
        .ignoresSafeArea(.container)
        .background(direction.paper.ignoresSafeArea())
        .onChange(of: reveal.isDragging) { _, dragging in
            if dragging { workspaceShown = true }
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: committedDrags)
    }

    private var workspace: some View {
        // Shelf links keep their native row look; choosing one moves the surface instead of pushing here.
        NavigationStack(path: Binding<[Shelf]>(get: { [] }, set: { if let shelf = $0.last { open(shelf) } })) {
            List {
                heading("Folio", caption: "Workspace")
                    .accessibilityIdentifier("workspace.heading")
                if let error = store.loadFailure {
                    Text(error)
                    Button("Try again") { store.reload() }
                } else {
                    shelf(.inbox, icon: "tray", id: "workspace.inbox")
                    shelf(.favorites, icon: "star", id: "workspace.favorites")
                    shelf(.recent, icon: "clock", id: "workspace.recent")
                    Section {
                        ForEach(store.library.folders) { folder in
                            shelf(.folder(folder.id), icon: "folder", id: "workspace.folder")
                        }
                        Button {
                            folderName = ""
                            newFolder = true
                        } label: {
                            Label("New Collection", systemImage: "folder.badge.plus")
                        }
                        .accessibilityIdentifier("workspace.addFolder")
                        .listRowBackground(Color.clear)
                    } header: {
                        Text("Collections").font(.subheadline.weight(.semibold))
                            .textCase(nil).accessibilityAddTraits(.isHeader)
                    }
                    let recent = store.notes(in: .recent).prefix(3)
                    if !recent.isEmpty {
                        Section("Continue writing") {
                            ForEach(recent) { note in
                                Button {
                                    open(.recent, then: [.note(note.id)])
                                } label: {
                                    Text(note.displayTitle).lineLimit(1)
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
            }
            .folioListStyle(direction)
            .scrollContentBackground(.hidden)
            .background(direction.paper.ignoresSafeArea())
            .navigationTitle("Workspace")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Shelf.self) { _ in EmptyView() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Note", systemImage: "square.and.pencil") { create(in: .inbox, fromWorkspace: true) }
                        .accessibilityIdentifier("workspace.compose")
                        .disabled(store.loadFailure != nil)
                }
            }
            .alert("New Collection", isPresented: $newFolder) {
                TextField("Collection name", text: $folderName)
                Button("Cancel", role: .cancel) {}
                Button("Create") {
                    if let id = store.addFolder(folderName) { open(.folder(id)) }
                }.disabled(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { saveFailure }
    }

    private var surface: some View {
        NavigationStack(path: $path) {
            CollectionScreen(store: store, shelf: shelf, direction: direction, reveal: reveal,
                             covered: reveal.isRevealed || reveal.isDragging,
                             memory: Binding(get: { memories[shelf, default: CollectionMemory()] },
                                             set: { memories[shelf] = $0 }),
                             showWorkspace: { settle(revealed: $0) }) { create(in: shelf) }
                .id(shelf)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .note(let id, let composing):
                        Editor(store: store, id: id, direction: direction, composing: composing,
                               memory: Binding(get: { selections[id, default: EditorMemory()] },
                                               set: { selections[id] = $0 }))
                            .onAppear { memories[shelf, default: CollectionMemory()].selectedNote = id }
                    }
                }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !reveal.isRevealed { saveFailure }
        }
    }

    @ViewBuilder private var saveFailure: some View {
        if let message = store.writeFailure {
            VStack(alignment: .leading, spacing: 8) {
                Text(message)
                Button("Retry save") { store.flush() }.fontWeight(.semibold)
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial)
            .accessibilityElement(children: .contain)
        }
    }

    private func heading(_ title: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: direction == .ledger ? 1 : 5) {
            if direction == .ledger {
                Text(caption.uppercased()).font(.caption.monospaced()).foregroundStyle(direction.accent)
            }
            Text(title).font(.system(.largeTitle, design: direction.serif, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.top, 8).padding(.bottom, 20)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    private func shelf(_ shelf: Shelf, icon: String, id: String) -> some View {
        NavigationLink(value: shelf) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: shelfIconWidth, alignment: .leading)
                    .accessibilityHidden(true)
                Text(store.title(shelf))
            }
            .font(.body.weight(.medium))
            .padding(.vertical, 7)
            .foregroundStyle(lastShelf == shelf ? direction.accent : .primary)
        }
        .accessibilityAddTraits(lastShelf == shelf ? .isSelected : [])
        .accessibilityIdentifier(id)
        .listRowBackground(Color.clear)
    }

    private func navigate(_ routes: [Route]) {
        if reduceMotion {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) { path.append(contentsOf: routes) }
        } else {
            path.append(contentsOf: routes)
        }
    }

    /// Shows a shelf on the surface, under cover of the workspace, then slides the surface back over it.
    private func open(_ next: Shelf, then routes: [Route] = []) {
        lastShelf = next
        if next != shelf || path != routes {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                shelf = next
                path = routes
            }
        }
        settle(revealed: false)
    }

    private func settle(revealed: Bool, velocity: Double = 0) {
        let initialVelocity = reveal.settle(revealed: revealed, velocity: velocity)
        let animation: Animation = reduceMotion
            ? .easeOut(duration: 0.2)
            : .interpolatingSpring(duration: WorkspaceReveal.duration, bounce: 0, initialVelocity: initialVelocity)
        if revealed { workspaceShown = true }
        withAnimation(animation, completionCriteria: .removed) {
            reveal.progress = revealed ? 1 : 0
        } completion: {
            if !reveal.isRevealed && !reveal.isDragging { workspaceShown = false }
        }
    }

    private func create(in shelf: Shelf, fromWorkspace: Bool = false) {
        guard let id = store.create(in: shelf) else { return }
        let route = Route.note(id, composing: true)
        if fromWorkspace { open(shelf, then: [route]) } else { navigate([route]) }
    }
}

/// Drives the reveal from a sideways drag where the platform recognizer is available; the leading control works everywhere.
private struct RevealGesture: ViewModifier {
    let enabled: Bool
    let reveal: WorkspaceReveal
    let distance: Double
    let settle: (Bool, Double) -> Void
    let committed: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 18, *) {
            content.gesture(WorkspaceRevealPan(
                isEnabled: enabled,
                isRevealed: reveal.isRevealed,
                began: { reveal.beginDrag() },
                changed: { reveal.drag($0, distance: distance) },
                ended: { velocity in
                    let revealed = reveal.target(releasing: velocity, distance: distance)
                    if revealed != reveal.isRevealed { committed() }
                    settle(revealed, velocity / distance)
                },
                cancelled: { settle(reveal.isRevealed, 0) }))
        } else {
            content
        }
    }
}

private struct CollectionScreen: View {
    let store: NoteStore
    let shelf: Shelf
    let direction: Direction
    let reveal: WorkspaceReveal
    /// The workspace is revealed or being revealed; the surface then only offers its close and search controls.
    let covered: Bool
    @Binding var memory: CollectionMemory
    let showWorkspace: (Bool) -> Void
    let create: () -> Void
    @FocusState private var searching: Bool

    var body: some View {
        let notes = store.notes(in: shelf, matching: memory.query)
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(store.title(shelf))
                    .font(.system(.largeTitle, design: direction.serif, weight: .semibold))
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("collection.heading")
                    .padding(.top, 12)
                    .padding(.bottom, 7)
                if notes.isEmpty {
                    if memory.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("No notes yet").foregroundStyle(.secondary)
                        Button("Write a note", action: create).fontWeight(.semibold)
                    } else {
                        Text("No matching notes").foregroundStyle(.secondary)
                    }
                }
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(notes) { note in
                        NavigationLink(value: Route.note(note.id)) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(note.displayTitle)
                                        .font(.system(.title3, design: direction.serif, weight: .semibold))
                                        .foregroundStyle(memory.selectedNote == note.id ? direction.accent : .primary)
                                        .lineLimit(2)
                                    let excerpt = note.body.prefix(400).split(whereSeparator: \.isWhitespace)
                                        .joined(separator: " ")
                                    if !excerpt.isEmpty {
                                        Text(excerpt).font(.callout)
                                            .foregroundStyle(.primary.opacity(0.74)).lineLimit(2)
                                    }
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "chevron.forward")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .accessibilityHidden(true)
                            }
                            .padding(.vertical, 13)
                            .frame(minHeight: 54)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("collection.note")
                        .accessibilityAddTraits(memory.selectedNote == note.id ? .isSelected : [])
                        .overlay(alignment: .bottom) { Divider().allowsHitTesting(false) }
                        .id(note.id)
                    }
                }
                .scrollTargetLayout()
                // Each query lays out its rows afresh; narrowing a scrolled list otherwise left them unrendered.
                .id(memory.query)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 22)
        }
        .scrollPosition(id: Binding(
            get: { memory.query.isEmpty ? memory.anchor : nil },
            set: { if memory.query.isEmpty { memory.anchor = $0 } }
        ), anchor: .top)
        .scrollDismissesKeyboard(.interactively)
        .allowsHitTesting(!covered)
        .accessibilityHidden(covered)
        .overlay {
            if covered {
                Color.clear.contentShape(Rectangle())
                    .onTapGesture { showWorkspace(false) }
                    .accessibilityHidden(true)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { searchBar }
        .background(direction.paper.ignoresSafeArea())
        .navigationTitle(memory.anchor == nil || memory.anchor == notes.first?.id ? "" : store.title(shelf))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // The collection's existing leading control: back toward the workspace at rest, the one close control once revealed.
                Button(reveal.showsClose ? "Close Workspace" : "Workspace",
                       systemImage: reveal.showsClose ? "xmark" : "chevron.backward") { showWorkspace(!reveal.isRevealed) }
                    .contentTransition(.symbolEffect(.replace))
                    .tint(.primary)
                    .accessibilityIdentifier("collection.workspace")
            }
            ToolbarItem(placement: .primaryAction) {
                Button("New Note", systemImage: "square.and.pencil", action: create)
                    .accessibilityIdentifier("collection.compose")
                    .accessibilityHidden(covered)
            }
        }
        .onChange(of: covered) { _, covered in
            if covered { searching = false }
        }
    }

    private var searchBar: some View {
        SearchBar(reveal: reveal, direction: direction, covered: covered) {
            TextField("Search notes", text: $memory.query, prompt: Text(""))
                .overlay(alignment: .leading) {
                    if memory.query.isEmpty {
                        Text("Search notes").foregroundStyle(.primary.opacity(0.65))
                            .allowsHitTesting(false).accessibilityHidden(true)
                    }
                }
                .focused($searching)
                .submitLabel(.search)
                .onSubmit { searching = false }
                .accessibilityIdentifier("collection.search")
            if !memory.query.isEmpty {
                Button("Clear search", systemImage: "xmark.circle.fill") { memory.query = "" }
                    .labelStyle(.iconOnly)
                    .frame(minWidth: 44, minHeight: 44)
            }
        } search: {
            showWorkspace(false)
            searching = true
        }
    }
}

/// The collection's search field; as the workspace is revealed it folds into a compact search button around its own glyph.
private struct SearchBar<Field: View>: View {
    let reveal: WorkspaceReveal
    let direction: Direction
    let covered: Bool
    @ViewBuilder let field: Field
    let search: () -> Void
    @ScaledMetric(relativeTo: .body) private var compact = 50.0

    var body: some View {
        let progress = min(max(reveal.progress, 0), 1)
        VStack(spacing: 0) {
            Divider().opacity(1 - progress)
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundStyle(direction.accent)
                    .background {
                        compactBackground
                            .frame(width: compact, height: compact)
                            .scaleEffect(0.6 + 0.4 * progress)
                            .opacity(progress)
                    }
                    .accessibilityHidden(true)
                HStack(spacing: 12) { field }
                    .opacity(max(0, 1 - progress * 2))
                    .allowsHitTesting(!covered)
                    .accessibilityHidden(covered)
            }
            .frame(minHeight: 50)
            .padding(.horizontal, 22)
        }
        .background(direction.paper)
        .overlay(alignment: .leading) {
            if covered {
                Button("Search notes", systemImage: "magnifyingglass", action: search)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.clear)
                    .frame(width: compact, height: compact)
                    .contentShape(Circle())
                    .padding(.leading, 22 + 9 - compact / 2)
                    .accessibilityIdentifier("collection.searchButton")
            }
        }
    }

    @ViewBuilder private var compactBackground: some View {
        if #available(iOS 26, *) {
            Circle().fill(.clear).glassEffect(.regular, in: Circle())
        } else {
            Circle().fill(.regularMaterial)
        }
    }
}

private struct Editor: View {
    let store: NoteStore
    let id: UUID
    let direction: Direction
    let composing: Bool
    @Binding var memory: EditorMemory
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focus: Field?
    @State private var remove = false
    @ScaledMetric(relativeTo: .body) private var lineSpacing = 5.0
    private enum Field { case title, body }

    var body: some View {
        Group {
            if let note = store.note(id) {
                VStack(alignment: .leading, spacing: 12) {
                    titleInput
                        .font(.system(.largeTitle, design: direction.serif, weight: .semibold))
                        .lineLimit(1...(focus == nil ? 7 : typeSize.isAccessibilitySize ? 2 : 4))
                        .focused($focus, equals: .title)
                        .accessibilityIdentifier("note.title")
                    Divider()
                    bodyInput
                        .scrollContentBackground(.hidden)
                        .scrollDismissesKeyboard(.interactively)
                        .font(.body)
                        .lineSpacing(lineSpacing)
                        .focused($focus, equals: .body)
                        .padding(.horizontal, -5)
                        .overlay(alignment: .topLeading) {
                            if note.body.isEmpty {
                                Text("Start writing").foregroundStyle(.primary.opacity(0.65))
                                    .padding(.top, 8)
                                    .allowsHitTesting(false).accessibilityHidden(true)
                            }
                        }
                        .accessibilityLabel("Note body")
                        .accessibilityIdentifier("note.body")
                }
                .padding(.horizontal, 22).padding(.top, 13)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button(note.favorite ? "Remove from Favorites" : "Add to Favorites",
                                   systemImage: note.favorite ? "star.slash" : "star") {
                                store.edit(id, \.favorite, !note.favorite)
                                store.flush()
                            }
                            Menu("Move to Collection", systemImage: "folder") {
                                Button("Inbox") { move(nil) }.disabled(note.folder == nil)
                                ForEach(store.library.folders) { folder in
                                    Button(folder.name) { move(folder.id) }.disabled(note.folder == folder.id)
                                }
                            }
                            Button("Delete Note", systemImage: "trash", role: .destructive) { remove = true }
                        } label: {
                            Label("Note actions", systemImage: "ellipsis")
                        }
                        .accessibilityIdentifier("note.actions")
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { focus = nil }.accessibilityLabel("Dismiss keyboard")
                    }
                }
                .alert("Delete note?", isPresented: $remove) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) { store.delete(id); dismiss() }
                }
            } else {
                ContentUnavailableView("Note unavailable", systemImage: "doc")
            }
        }
        .background(direction.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard composing else { return }
            do { try await Task.sleep(for: .milliseconds(220)) } catch { return }
            if focus == nil { focus = .title }
        }
        .onDisappear { store.flush() }
    }

    @ViewBuilder private var titleInput: some View {
        if #available(iOS 18, *) {
            TextField("Title", text: value(\.title), selection: selection(\.title, text: \.title), axis: .vertical)
        } else {
            TextField("Title", text: value(\.title), axis: .vertical)
        }
    }

    @ViewBuilder private var bodyInput: some View {
        if #available(iOS 18, *) {
            TextEditor(text: value(\.body), selection: selection(\.body, text: \.body))
        } else {
            TextEditor(text: value(\.body))
        }
    }

    @available(iOS 18, *)
    private func selection(
        _ key: WritableKeyPath<EditorMemory, NSRange?>,
        text keyPath: KeyPath<Note, String>
    ) -> Binding<TextSelection?> {
        Binding(get: {
            guard let text = store.note(id)?[keyPath: keyPath],
                  let offset = memory[keyPath: key],
                  let range = Range(offset, in: text) else { return nil }
            return range.isEmpty ? TextSelection(insertionPoint: range.lowerBound) : TextSelection(range: range)
        }, set: { selection in
            guard let text = store.note(id)?[keyPath: keyPath], let selection,
                  case .selection(let range) = selection.indices,
                  let start = range.lowerBound.samePosition(in: text.utf16),
                  let end = range.upperBound.samePosition(in: text.utf16),
                  start <= end else { return }
            let utf16 = text.utf16
            let offset = NSRange(location: utf16.distance(from: utf16.startIndex, to: start),
                                 length: utf16.distance(from: start, to: end))
            if memory[keyPath: key] != offset { memory[keyPath: key] = offset }
        })
    }

    private func move(_ folder: UUID?) {
        store.edit(id, \.folder, folder)
        store.flush()
    }

    private func value(_ key: WritableKeyPath<Note, String>) -> Binding<String> {
        Binding(get: { store.note(id)?[keyPath: key] ?? "" }, set: { store.edit(id, key, $0) })
    }
}
