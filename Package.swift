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
    targets: [
        .target(name: "WordleSolver"),
        .target(name: "solve_wordle", dependencies: ["WordleSolver"]),
        .testTarget(name: "WordleSolverTests", dependencies: ["WordleSolver"]),
    ]
)
