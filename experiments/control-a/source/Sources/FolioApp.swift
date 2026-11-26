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

/// A horizontal drag that moves the main surface over the workspace. It starts from where the surface rests and
/// follows the finger in both directions until it lifts.
private struct RevealDrag {
    var start: CGFloat
    var progress: CGFloat
    var horizontal: Bool
}

private struct Workspace: View {
    let store: NoteStore
    let direction: Direction
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var path: [Route] = []
    @State private var current: Shelf = .inbox
    @State private var lastShelf: Shelf?
    @State private var revealed = true
    @State private var drag: RevealDrag?
    /// False once the surface has settled over the workspace, so the hidden workspace leaves the accessibility tree.
    @State private var workspaceMounted = true
    @State private var memories: [Shelf: CollectionMemory] = [:]
    @State private var selections: [UUID: EditorMemory] = [:]
    @ScaledMetric(relativeTo: .body) private var shelfIconWidth = 28.0
    @State private var newFolder = false
    @State private var folderName = ""
    /// How much of the main surface stays visible beside the workspace: room for its close and search controls.
    private let peek = 76.0

    private var progress: CGFloat {
        if let drag, drag.horizontal { return drag.progress }
        return revealed ? 1 : 0
    }

    var body: some View {
        GeometryReader { proxy in
            let travel = min(proxy.size.width - peek, 420)
            let progress = progress
            ZStack(alignment: .topLeading) {
                if workspaceMounted {
                    workspace
                        .frame(width: travel)
                        .offset(x: (progress - 1) * travel * 0.18)
                        .opacity(progress == 0 ? 0 : 1)
                        .allowsHitTesting(revealed)
                        .accessibilityHidden(!revealed)
                        .accessibilityAction(.escape) { setRevealed(false) }
                        .transition(.identity)
                }
                surface(progress: progress)
                    .offset(x: progress * travel)
            }
            .contentShape(Rectangle())
            .modifier(RevealGesture(enabled: path.isEmpty,
                                    changed: { revealChanged($0, travel: travel) },
                                    ended: { revealEnded(predicted: $0, velocity: $1, travel: travel) }))
        }
        .ignoresSafeArea(.container)
        .background(direction.paper.ignoresSafeArea())
        .sensoryFeedback(.impact(weight: .light), trigger: revealed)
    }

    private var workspace: some View {
        NavigationStack {
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
                                    show(.recent, then: [.note(note.id)])
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
                    if let id = store.addFolder(folderName) { show(.folder(id)) }
                }.disabled(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .ignoresSafeArea(.container)
    }

    /// The open collection and its notes. It stays alive while the workspace is revealed, so its search, scroll
    /// position, selection and any editing state are exactly as they were when it slides back.
    private func surface(progress: CGFloat) -> some View {
        NavigationStack(path: $path) {
            CollectionScreen(store: store, shelf: current, direction: direction,
                             memory: Binding(get: { memories[current, default: CollectionMemory()] },
                                             set: { memories[current] = $0 }),
                             revealed: revealed, progress: progress,
                             showWorkspace: { setRevealed($0) }) { create(in: current) }
                .id(current)
                .navigationDestination(for: Route.self) { route in
                    if case .note(let id, let composing) = route {
                        Editor(store: store, id: id, direction: direction, composing: composing,
                               memory: Binding(get: { selections[id, default: EditorMemory()] },
                                               set: { selections[id] = $0 }))
                            .onAppear { memories[current, default: CollectionMemory()].selectedNote = id }
                    }
                }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
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
        .ignoresSafeArea(.container)
        .clipShape(SurfaceShape(progress: progress))
        .overlay {
            SurfaceShape(progress: progress)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
                .opacity(progress)
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.18 * progress), radius: 24)
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
        Button { show(shelf) } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: shelfIconWidth, alignment: .leading)
                    .accessibilityHidden(true)
                Text(store.title(shelf))
                Spacer(minLength: 0)
                Image(systemName: "chevron.forward")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color(uiColor: .tertiaryLabel))
                    .accessibilityHidden(true)
            }
            .font(.body.weight(.medium))
            .padding(.vertical, 7)
            .foregroundStyle(lastShelf == shelf ? direction.accent : .primary)
        }
        .accessibilityAddTraits(lastShelf == shelf ? .isSelected : [])
        .accessibilityIdentifier(id)
        .listRowBackground(Color.clear)
    }

    /// Follows the finger in both directions, then settles where the release was heading.
    private func revealChanged(_ translation: CGSize, travel: CGFloat) {
        if drag == nil {
            workspaceMounted = true
            let start: CGFloat = revealed ? 1 : 0
            drag = RevealDrag(start: start, progress: start,
                              horizontal: abs(translation.width) > abs(translation.height))
        }
        guard let current = drag, current.horizontal else { return }
        drag?.progress = min(max(current.start + translation.width / travel, 0), 1)
    }

    private func revealEnded(predicted: CGFloat, velocity: CGFloat, travel: CGFloat) {
        guard let current = drag, current.horizontal else { drag = nil; return }
        let open = current.start + predicted / travel > 0.5
        let remaining = (open ? 1 : 0) - current.progress
        let relative = abs(remaining) < 0.01 ? 0 : velocity / travel / remaining
        setRevealed(open, velocity: min(max(relative, 0), 20))
    }

    private func setRevealed(_ open: Bool, velocity: CGFloat = 0) {
        if open { workspaceMounted = true }
        if reduceMotion {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) { drag = nil; revealed = open }
            workspaceMounted = open
        } else {
            withAnimation(.interpolatingSpring(mass: 1, stiffness: 320, damping: 35, initialVelocity: velocity)) {
                drag = nil
                revealed = open
            } completion: {
                if !revealed && drag == nil { workspaceMounted = false }
            }
        }
    }

    /// Puts a collection (and optionally a note in it) on the main surface, then slides the surface back.
    private func show(_ shelf: Shelf, then routes: [Route] = []) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            lastShelf = shelf
            current = shelf
            path = routes
        }
        setRevealed(false)
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

    private func create(in shelf: Shelf, fromWorkspace: Bool = false) {
        guard let id = store.create(in: shelf) else { return }
        let route = Route.note(id, composing: true)
        if fromWorkspace { show(shelf, then: [route]) } else { navigate([route]) }
    }
}

/// Drives the reveal from horizontal drags anywhere on the workspace or the collection. Vertical drags stay with
/// the scroll views, and a pushed note keeps the system back swipe.
private struct RevealGesture: ViewModifier {
    let enabled: Bool
    let changed: (CGSize) -> Void
    let ended: (_ predicted: CGFloat, _ velocity: CGFloat) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 18, *) {
            content.gesture(RevealPan(enabled: enabled, changed: changed, ended: ended))
        } else {
            content.simultaneousGesture(
                DragGesture(minimumDistance: 12, coordinateSpace: .global)
                    .onChanged { changed($0.translation) }
                    .onEnded { ended($0.predictedEndTranslation.width, $0.velocity.width) },
                including: enabled ? .all : .subviews)
        }
    }
}

/// A UIKit pan measured in window coordinates. SwiftUI's drag reads the touch through the view under the finger,
/// so a finger resting on the still-settling surface registered as movement and flung the workspace open again.
@available(iOS 18, *)
private struct RevealPan: UIGestureRecognizerRepresentable {
    let enabled: Bool
    let changed: (CGSize) -> Void
    let ended: (_ predicted: CGFloat, _ velocity: CGFloat) -> Void

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool {
            guard let pan = recognizer as? UIPanGestureRecognizer else { return false }
            let velocity = pan.velocity(in: pan.view?.window)
            return abs(velocity.x) > abs(velocity.y)
        }

        /// Scrolling may continue alongside; anything else under the finger, such as a note row, is cancelled
        /// once the reveal takes over, as the system back swipe does.
        func gestureRecognizer(_ recognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            other.view is UIScrollView
        }
    }

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator { Coordinator() }

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer()
        pan.delegate = context.coordinator
        return pan
    }

    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = enabled
    }

    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        let window = recognizer.view?.window
        let translation = recognizer.translation(in: window)
        switch recognizer.state {
        case .began, .changed:
            changed(CGSize(width: translation.x, height: translation.y))
        case .ended:
            let velocity = recognizer.velocity(in: window).x
            ended(translation.x + velocity * 0.25, velocity)
        case .cancelled, .failed:
            ended(translation.x, 0)
        default:
            break
        }
    }
}

/// The main surface's outline: square while it fills the screen, rounded like the display once it moves aside.
private struct SurfaceShape: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        RoundedRectangle(cornerRadius: 52 * min(max(progress * 4, 0), 1), style: .continuous).path(in: rect)
    }
}

private struct CollectionScreen: View {
    let store: NoteStore
    let shelf: Shelf
    let direction: Direction
    @Binding var memory: CollectionMemory
    /// The workspace is open: the surface is a strip that only closes or searches.
    let revealed: Bool
    /// 0 while the surface fills the screen, 1 when it rests beside the workspace.
    let progress: CGFloat
    let showWorkspace: (Bool) -> Void
    let create: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var searching: Bool
    @State private var searchAfterClose = false
    @Namespace private var morph
    private static let top = "collection.top"
    private var compact: Bool { progress > 0 }

    var body: some View {
        let notes = store.notes(in: shelf, matching: memory.query)
        ScrollView {
            ScrollViewReader { reader in
                VStack(alignment: .leading, spacing: 12) {
                    Text(store.title(shelf))
                        .font(.system(.largeTitle, design: direction.serif, weight: .semibold))
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("collection.heading")
                        .id(Self.top)
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 22)
                // A search starts at the top, so a deep browsing offset never hangs over a short result list.
                .onChange(of: memory.query.isEmpty) { _, browsing in
                    if !browsing { reader.scrollTo(Self.top, anchor: .top) }
                }
            }
        }
        .scrollPosition(id: Binding(
            get: { memory.query.isEmpty ? memory.anchor : nil },
            set: { if memory.query.isEmpty { memory.anchor = $0 } }
        ), anchor: .top)
        .scrollDismissesKeyboard(.interactively)
        .opacity(1 - 0.5 * progress)
        .allowsHitTesting(!revealed)
        .accessibilityHidden(revealed)
        .overlay {
            if revealed {
                Color.clear.contentShape(Rectangle())
                    .onTapGesture { showWorkspace(false) }
                    .accessibilityHidden(true)
                    .transition(.identity)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { searchBar }
        .background(direction.paper.ignoresSafeArea())
        .navigationTitle(memory.anchor == nil || memory.anchor == notes.first?.id ? "" : store.title(shelf))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: compact) { _, compact in
            if compact { searching = false }
        }
        .task(id: compact) {
            // The field is back in the layout by now, so it can take focus.
            guard !compact, searchAfterClose else { return }
            searchAfterClose = false
            searching = true
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                let close = progress > 0.5
                Button { showWorkspace(!revealed) } label: {
                    Label(close ? "Close Workspace" : "Show Workspace",
                          systemImage: close ? "xmark" : "line.3.horizontal")
                        .contentTransition(.symbolEffect(.replace))
                }
                .animation(reduceMotion ? nil : .smooth(duration: 0.25), value: close)
                .accessibilityIdentifier("collection.menu")
            }
            ToolbarItem(placement: .primaryAction) {
                Button("New Note", systemImage: "square.and.pencil", action: create)
                    .accessibilityIdentifier("collection.compose")
            }
        }
    }

    /// The search field while the surface fills the screen; a round search button at the surface's edge while the
    /// workspace is open. The field keeps its place in the layout so the notes above never shift.
    private var searchBar: some View {
        ZStack(alignment: .leading) {
            searchField
                .opacity(compact ? 0 : 1)
                .allowsHitTesting(!compact)
                .accessibilityHidden(compact)
            if compact {
                searchButton
                    .padding(.leading, 16)
                    .transition(.scale(scale: 0.6, anchor: .leading).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? nil : .smooth(duration: 0.3), value: compact)
    }

    @ViewBuilder private var searchButton: some View {
        let button = Button {
            searchAfterClose = true
            showWorkspace(false)
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.body.weight(.medium))
                .foregroundStyle(direction.accent)
                .matchedGeometryEffect(id: "magnifier", in: morph)
                .frame(width: 48, height: 48)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Search notes")
        .accessibilityIdentifier("collection.searchButton")
        if #available(iOS 26, *) {
            button.glassEffect(.regular.interactive(), in: .circle)
        } else {
            button.background(.regularMaterial, in: Circle())
        }
    }

    private var searchField: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundStyle(direction.accent)
                    .matchedGeometryEffect(id: "magnifier", in: morph, isSource: !compact)
                    .accessibilityHidden(true)
                if compact {
                    // Holds the field's place while it is hidden, without leaving a focusable field behind.
                    Text(memory.query.isEmpty ? "Search notes" : memory.query).lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
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
                }
            }
            .frame(minHeight: 50)
            .padding(.horizontal, 22)
        }
        .background(direction.paper)
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
