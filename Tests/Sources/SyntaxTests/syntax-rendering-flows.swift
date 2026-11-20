import Syntax
import SyntaxANSI
import SyntaxHTML
import SyntaxStyling
import Testing

extension SyntaxTestSuite {
    static var renderingSuite: TestSuite {
        TestSuite("syntax-rendering") {
            Test("theme families resolve explicitly without renderer defaults") {
                let themes = SyntaxThemes(dark: .dark.adding([
                    .init(selector: .init(role: .keyword), style: .init(underline: true))
                ]))
                try Expect.equal(themes.theme(for: .light).name, "light", "light preset")
                try Expect.equal(themes.theme(for: .dark).name, "dark", "dark preset")
            }

            Test("ANSI and HTML share exact styled Unicode source") {
                let language = try SyntaxLanguage<ECKind>(id: "ec", definitions: [
                    .init(kind: .entry, role: .keyword)
                ])
                let capture = try SyntaxCapture(
                    language: "ec", kind: ECKind.entry,
                    segments: [try SyntaxSourceRange(0..<5)], layer: .lexical
                )
                let document = try SyntaxDocument(
                    source: "entry\r\n🙂 <&", vocabularies: [language.vocabulary()],
                    captures: [capture]
                )
                let styled = try SyntaxStyling.project(document: document, theme: .dark)
                let ansi = try SyntaxANSI.render(document: document, lines: styled)
                try Expect.equal(ansi.contains("38;2;190;145;255"), true, "dark style")
                let plain = try SyntaxStyling.project(document: document, theme: .plain)
                try Expect.equal(try SyntaxANSI.render(document: document, lines: plain),
                                 document.source, "lossless plain source")
                let html = try SyntaxHTML.render(document: document, lines: styled)
                try Expect.equal(html.contains("🙂 &lt;&amp;"), true, "escaped HTML")
                try Expect.equal(html.contains("\r\n"), true, "CRLF retained")
                let numbered = try SyntaxANSI.render(
                    document: document, lines: plain,
                    layout: .init(lineNumbers: true, startingLine: 7)
                )
                try Expect.equal(numbered.hasPrefix("7 | entry"), true, "layout independent")
            }
        }
    }
}
