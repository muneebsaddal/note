// Run with ./check.sh
import Foundation

Note.url = FileManager.default.temporaryDirectory
    .appendingPathComponent(UUID().uuidString).appendingPathComponent("note.txt")

assert(Note.load() == "", "missing file reads as empty")
try Note.save("a thought\n✓ second line")
assert(Note.load() == "a thought\n✓ second line", "text survives a save")
try Note.save("")
assert(Note.load() == "", "clear empties the note")
assert(Note.peek("") == "", "blank note has no peek")
assert(Note.peek(" \n\n  \n") == "", "whitespace only has no peek")
assert(Note.peek("\n  first  \nsecond") == "first", "skips blank lines and trims")
assert(Note.peek(String(repeating: "a", count: 25)) == String(repeating: "a", count: 25), "exact limit stays whole")
assert(Note.peek(String(repeating: "a", count: 26)) == String(repeating: "a", count: 25) + "…", "long line is cut")
print("ok")
