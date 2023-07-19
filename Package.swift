// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SketchPad",
    // TODO: When get CLI use to use async?
     platforms: [
         .macOS(.v13),
     ],
    products: [
        .library(name: "SketchPad", targets: ["SketchPad"]),
        .executable(name: "sketchpad", targets: ["SketchPadCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2")
    ],
    targets: [
        .target(
            name: "SketchPad"
        ),
        .testTarget(name: "FileBuilderTests", dependencies: ["SketchPad"]),
        .testTarget(name: "SketchPadTests", dependencies: ["SketchPad"]),
        .executableTarget(
            name: "SketchPadCLI",
            dependencies: [
                "SketchPad",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)

let swiftSettings: [SwiftSetting] = [
    // -enable-bare-slash-regex becomes
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    // -warn-concurrency becomes
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags(["-enable-actor-data-race-checks"],
        .when(configuration: .debug)),
]

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: swiftSettings)
}
