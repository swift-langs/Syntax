/// Source-line layout, independent of appearance and serialization format.
public struct SyntaxSourceLayout: Sendable, Equatable {
    public let lineNumbers: Bool
    public let startingLine: Int

    public init(lineNumbers: Bool = false, startingLine: Int = 1) {
        self.lineNumbers = lineNumbers
        self.startingLine = startingLine
    }
}
