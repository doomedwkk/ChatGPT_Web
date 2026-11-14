import AppKit
import Foundation

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: render-app-icon.swift input.svg output.png\n", stderr)
    exit(2)
}
let input = URL(fileURLWithPath: CommandLine.arguments[1])
let output = URL(fileURLWithPath: CommandLine.arguments[2])
guard let image = NSImage(contentsOf: input) else {
    fputs("Could not load SVG app icon: \(input.path)\n", stderr)
    exit(1)
}
image.size = NSSize(width: 1024, height: 1024)
var rect = CGRect(origin: .zero, size: image.size)
guard let cgImage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
    fputs("Could not rasterize SVG app icon\n", stderr)
    exit(1)
}
let bitmap = NSBitmapImageRep(cgImage: cgImage)
bitmap.size = NSSize(width: 1024, height: 1024)
guard let data = bitmap.representation(using: .png, properties: [:]) else {
    fputs("Could not encode PNG app icon\n", stderr)
    exit(1)
}
try data.write(to: output, options: .atomic)
print("Generated app icon: \(output.path)")
