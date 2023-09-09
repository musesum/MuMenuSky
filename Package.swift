// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "MuMenuSky",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MuMenuSky",
            targets: ["MuMenuSky"]),
    ],
    dependencies: [
        .package(url: "https://github.com/musesum/MuFlo.git", .branch("main")),
        .package(url: "https://github.com/musesum/MuSkyFlo.git",.branch("main")),
    ],
    targets: [
        .target(
            name: "MuMenuSky",
            dependencies: [
                .product(name: "MuSkyFlo", package: "MuSkyFlo"),
                .product(name: "MuFlo", package: "MuFlo")],
            resources: [.process("Resources")]),
        .testTarget(
            name: "MuMenuSkyTests",
            dependencies: ["MuSkyFlo","MuFlo"]),

    ]
)
