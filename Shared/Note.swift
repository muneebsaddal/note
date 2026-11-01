import Foundation

/// The one note. A plain text file both the app and the widget can reach.
enum Note {
    // shortcut: uses a sandbox exception because locally signed builds cannot write to an app group; move to an app group if this ever gets a developer identity.
    // getpwuid because the sandbox reports the app's container as home.
    static var url = URL(fileURLWithPath: String(cString: getpwuid(getuid()).pointee.pw_dir))
        .appendingPathComponent("Library/Application Support/note/note.txt")

    static func load() -> String {
        (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    }

    static func save(_ text: String) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try text.write(to: url, atomically: true, encoding: .utf8)
    }
}
