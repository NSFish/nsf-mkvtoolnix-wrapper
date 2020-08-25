// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "nsf-mkvtoolnix-wrapper",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        .target(
            name: "nsf-mkvtoolnix-wrapper",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "nsf-mkvtoolnix-wrapperTests",
            dependencies: ["nsf-mkvtoolnix-wrapper"]),
    ]
)
