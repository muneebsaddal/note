// Run with ./check.sh
import Foundation

Note.url = FileManager.default.temporaryDirectory
    .appendingPathComponent(UUID().uuidString).appendingPathComponent("note.txt")

assert(Note.load() == "", "missing file reads as empty")
try Note.save("a thought\n✓ second line")
assert(Note.load() == "a thought\n✓ second line", "text survives a save")
try Note.save("")
assert(Note.load() == "", "clear empties the note")
print("ok")
