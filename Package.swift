// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Syntax",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "Syntax", targets: ["Syntax"]),
        .library(name: "SyntaxStyling", targets: ["SyntaxStyling"]),
        .library(name: "SyntaxLSP", targets: ["SyntaxLSP"]),
        .library(name: "SyntaxANSI", targets: ["SyntaxANSI"]),
        .library(name: "SyntaxHTML", targets: ["SyntaxHTML"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-lco/Position.git", branch: "master"),
        .package(url: "https://github.com/swift-lco/Primitives.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "Syntax",
            dependencies: [
                .product(name: "Position", package: "Position"),
                .product(name: "Primitives", package: "Primitives")
            ]
        ),
        .target(
            name: "SyntaxStyling",
            dependencies: ["Syntax"]
        ),
        .target(
            name: "SyntaxLSP",
            dependencies: [
                "Syntax",
                .product(name: "Position", package: "Position")
            ]
        ),
        .target(name: "SyntaxANSI", dependencies: ["Syntax", "SyntaxStyling"]),
        .target(name: "SyntaxHTML", dependencies: ["Syntax", "SyntaxStyling"]),
    ]
)

for target in package.targets {
    switch target.type {
    case .regular, .executable, .test, .macro:
        var settings = target.swiftSettings ?? []

        settings.append(
            .treatAllWarnings(as: .error)
        )

        settings.append(
            .unsafeFlags(
                [
                    "-continue-building-after-errors"
                ]
            )
        )

        target.swiftSettings = settings

    case .plugin, .system, .binary:
        break

    @unknown default:
        break
    }
}
