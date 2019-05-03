// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ipa-parse",
    products: [
        .executable(name: "ipa-parse", targets: ["ipa-parse"]),
        .library(name: "IpaParserLib", targets: ["IpaParserLib"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ipa-parse",
            dependencies: ["IpaParserLib"]),
        .target(
            name: "IpaParserLib",
            dependencies: []),
        .testTarget(
            name: "ipa-parseTests",
            dependencies: ["IpaParserLib"]),
    ]
)
