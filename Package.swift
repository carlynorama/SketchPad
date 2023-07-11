// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SketchPad",
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
         .executableTarget(
            name: "SketchPadCLI",
            dependencies: [
                "SketchPad",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
         )
    ]
)
