import SwiftUI
import WidgetKit

struct NoteEntry: TimelineEntry {
    var date = Date.now
    var text: String
}

struct NoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> NoteEntry { NoteEntry(text: "") }

    func getSnapshot(in context: Context, completion: @escaping (NoteEntry) -> Void) {
        completion(NoteEntry(text: Note.load()))
    }

    // The app asks for a reload, so no schedule is needed.
    func getTimeline(in context: Context, completion: @escaping (Timeline<NoteEntry>) -> Void) {
        completion(Timeline(entries: [NoteEntry(text: Note.load())], policy: .never))
    }
}

struct NoteWidgetView: View {
    @Environment(\.colorScheme) private var scheme
    let entry: NoteEntry

    private var ink: Color { scheme == .dark ? .white : .black }

    var body: some View {
        Text(entry.text)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .foregroundStyle(ink)
            .containerBackground(scheme == .dark ? Color.black : .white, for: .widget)
    }
}

@main
struct NoteWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Note", provider: NoteProvider()) {
            NoteWidgetView(entry: $0)
        }
        .configurationDisplayName("note")
        .description("Your note.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
