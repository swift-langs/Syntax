import Syntax
import SyntaxStyling

/// ANSI serialization of already resolved SyntaxStyle values.
public enum SyntaxANSI {
    public static func render(
        document: SyntaxDocument,
        lines: [StyledSyntaxLine],
        layout: SyntaxSourceLayout = .init()
    ) throws -> String {
        var result = ""
        for line in lines {
            if layout.lineNumbers {
                result += "\(layout.startingLine + line.source.index) | "
            }
            for run in line.runs {
                guard let text = document.text(in: run.source.range) else {
                    throw SyntaxError.unaligned_boundary(offset: run.source.range.start.offset)
                }
                result += styled(String(text), style: run.style)
            }
            guard let ending = document.text(in: line.source.terminator) else {
                throw SyntaxError.unaligned_boundary(offset: line.source.terminator.start.offset)
            }
            result += ending
        }
        return result
    }

    private static func styled(_ text: String, style: SyntaxStyle) -> String {
        var codes: [String] = []
        if let color = style.foreground {
            codes.append("38;2;\(color.red);\(color.green);\(color.blue)")
        }
        if let color = style.background {
            codes.append("48;2;\(color.red);\(color.green);\(color.blue)")
        }
        if let bold = style.bold { codes.append(bold ? "1" : "22") }
        if let italic = style.italic { codes.append(italic ? "3" : "23") }
        if let underline = style.underline { codes.append(underline ? "4" : "24") }
        guard !codes.isEmpty else { return text }
        return "\u{001B}[\(codes.joined(separator: ";"))m\(text)\u{001B}[0m"
    }
}
