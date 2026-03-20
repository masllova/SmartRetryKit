// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartRetryKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SmartRetryKit",
            targets: ["SmartRetryKit"]
        ),
    ],
    targets: [
        .target(
            name: "SmartRetryKit",
            dependencies: []
        ),

    ]
)
