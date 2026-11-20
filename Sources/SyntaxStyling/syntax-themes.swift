/// A language can supply only the variants it customizes.
public enum SyntaxAppearance: Sendable, Equatable {
    case light
    case dark
}

public struct SyntaxThemes: Sendable {
    public let light: SyntaxTheme
    public let dark: SyntaxTheme

    public init(light: SyntaxTheme = .light, dark: SyntaxTheme = .dark) {
        self.light = light
        self.dark = dark
    }

    public func theme(for appearance: SyntaxAppearance) -> SyntaxTheme {
        switch appearance {
        case .light: light
        case .dark: dark
        }
    }
}
