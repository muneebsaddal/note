// Draws the glyph layer of note/AppIcon.icon. Run with: swift make-icon.swift note/AppIcon.icon/Assets/glyph.png
// macOS supplies the shape and background. A plain PNG icon gets shrunk onto a grey plate.
import AppKit

let size = 1024
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8,
    samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

// Same layout as Terminal's icon: bright glyph top left, grey underscore.
let font = NSFont.monospacedSystemFont(ofSize: 422, weight: .bold)
NSAttributedString(string: "n", attributes: [.font: font, .foregroundColor: NSColor.white])
    .draw(at: NSPoint(x: 146, y: 564 + font.descender))

NSGradient(colors: [NSColor(white: 0.82, alpha: 1), NSColor(white: 0.55, alpha: 1)])!
    .draw(in: NSBezierPath(roundedRect: NSRect(x: 422, y: 492, width: 224, height: 37), xRadius: 10, yRadius: 10), angle: -90)

NSGraphicsContext.current = nil
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
