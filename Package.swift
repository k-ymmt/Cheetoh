// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cheetoh",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Cheetoh",
            targets: ["Cheetoh"]),
        .executable(
            name: "Example",
            targets: ["Example"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax", branch: "0.50600.0-SNAPSHOT-2022-01-24")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Cheetoh",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ]),
        .testTarget(
            name: "CheetohTests",
            dependencies: ["Cheetoh"]),

        .target(
          name: "Example",
          dependencies: ["Cheetoh"]),
    ]
)
