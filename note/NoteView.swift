import SwiftUI
import WidgetKit

struct NoteView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var text = Note.load()
    @State private var saveFailed = false
    @FocusState private var focused: Bool

    private var ink: Color { scheme == .dark ? .white : .black }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextEditor(text: $text)
                .font(.system(size: 17))
                .foregroundStyle(ink)
                .tint(ink)
                .scrollContentBackground(.hidden)
                .focused($focused)
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 40)

            if saveFailed {
                Text("Not saved")
                    .font(.system(size: 13))
                    .foregroundStyle(.red)
                    .padding(16)
            }

            // No visible button. Invisible so Cmd+K still clears.
            Button("Clear") { text = "" }
                .keyboardShortcut("k")
                .opacity(0)
                .allowsHitTesting(false)
        }
        .frame(minWidth: 280, minHeight: 180)
        .onAppear { focused = true }
        .onExitCommand { NSApp.hide(nil) }
        .onChange(of: text) {
            do {
                try Note.save(text)
                saveFailed = false
            } catch {
                saveFailed = true
            }
        }
        // Reload the widget once typing pauses, not on every key.
        .task(id: text) {
            try? await Task.sleep(for: .milliseconds(500))
            if !Task.isCancelled { WidgetCenter.shared.reloadAllTimelines() }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            focused = true
        }
    }
}
