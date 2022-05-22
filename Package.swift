// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "wordle-solver",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "WordleSolver",
            targets: ["WordleSolver"]),
        .executable(
            name: "solve_wordle",
            targets: ["solve_wordle"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.0.0"),
    ],
    targets: [
        .target(name: "WordleSolver"),
        .target(name: "solve_wordle", dependencies: [
            "WordleSolver",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .testTarget(name: "WordleSolverTests", dependencies: ["WordleSolver"]),
    ]
)
