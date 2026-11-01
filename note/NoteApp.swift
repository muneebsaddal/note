import AppKit
import Carbon.HIToolbox
import SwiftUI

@main
struct NoteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Settings is only here so SwiftUI supplies the Edit menu (copy, paste, undo).
    var body: some Scene {
        Settings { EmptyView() }
            .commands { CommandGroup(replacing: .appSettings) {} }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var shared: AppDelegate!

    private var window: NSWindow!
    private var statusItem: NSStatusItem!
    private var hotKey: EventHotKeyRef?

    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 460, height: 320),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.isReleasedWhenClosed = false
        window.backgroundColor = NSColor(name: nil) {
            $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? .black : .white
        }
        window.contentView = NSHostingView(rootView: NoteView())
        window.center()
        window.setFrameAutosaveName("Note")

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.target = self
        statusItem.button?.action = #selector(toggle)
        statusItem.button?.image = NSImage(systemSymbolName: "note.text", accessibilityDescription: "note")

        registerHotKey()
        show()
    }

    func applicationDidBecomeActive(_ notification: Notification) { show() }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        show()
        return true
    }

    @objc func toggle() {
        if NSApp.isActive && window.isKeyWindow { NSApp.hide(nil) } else { show() }
    }

    private func show() {
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }

    /// Control-Option-N from anywhere. Carbon is the one system hotkey API that needs no permissions.
    private func registerHotKey() {
        var type = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, _, _ in
            DispatchQueue.main.async { AppDelegate.shared.toggle() }
            return noErr
        }, 1, &type, nil, nil)
        RegisterEventHotKey(
            UInt32(kVK_ANSI_N), UInt32(controlKey | optionKey),
            EventHotKeyID(signature: OSType(0x4D4E4E54), id: 1),
            GetApplicationEventTarget(), 0, &hotKey)
    }
}
