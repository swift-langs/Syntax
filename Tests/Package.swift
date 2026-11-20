// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SyntaxTests",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "t_syntax", targets: ["SyntaxTests"])
    ],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/Position.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Testing.git", branch: "master"),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "SyntaxTests",
            dependencies: [
                .product(name: "Syntax", package: "Syntax"),
                .product(name: "SyntaxStyling", package: "Syntax"),
                .product(name: "SyntaxLSP", package: "Syntax"),
                .product(name: "SyntaxANSI", package: "Syntax"),
                .product(name: "SyntaxHTML", package: "Syntax"),
                .product(name: "Position", package: "Position"),
                .product(name: "Testing", package: "Testing")
            ]
        )
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
