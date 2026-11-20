import Foundation
import Syntax
import SyntaxStyling

/// HTML serialization of source with resolved styles; no theme selection.
public enum SyntaxHTML {
    public static func render(
        document: SyntaxDocument,
        lines: [StyledSyntaxLine],
        layout: SyntaxSourceLayout = .init()
    ) throws -> String {
        var result = "<pre class=\"syntax-source\"><code>"
        for line in lines {
            if layout.lineNumbers {
                result += escape("\(layout.startingLine + line.source.index) | ")
            }
            for run in line.runs {
                guard let text = document.text(in: run.source.range) else {
                    throw SyntaxError.unaligned_boundary(offset: run.source.range.start.offset)
                }
                let value = escape(String(text))
                let style = css(for: run.style)
                result += style.isEmpty ? value : "<span style=\"\(style)\">\(value)</span>"
            }
            guard let ending = document.text(in: line.source.terminator) else {
                throw SyntaxError.unaligned_boundary(offset: line.source.terminator.start.offset)
            }
            result += escape(String(ending))
        }
        result += "</code></pre>"
        return result
    }

    private static func css(for style: SyntaxStyle) -> String {
        var rules: [String] = []
        if let color = style.foreground {
            rules.append("color:rgb(\(color.red),\(color.green),\(color.blue))")
        }
        if let color = style.background {
            rules.append("background-color:rgb(\(color.red),\(color.green),\(color.blue))")
        }
        if let bold = style.bold { rules.append("font-weight:\(bold ? "bold" : "normal")") }
        if let italic = style.italic { rules.append("font-style:\(italic ? "italic" : "normal")") }
        if let underline = style.underline {
            rules.append("text-decoration:\(underline ? "underline" : "none")")
        }
        return rules.joined(separator: ";")
    }

    private static func escape(_ text: String) -> String {
        text.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
