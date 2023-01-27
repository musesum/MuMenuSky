// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(url: "https://github.com/musesum/MuFlo.git", from: "0.23.0"),
        .package(url: "https://github.com/musesum/MuMenu.git", from: "0.23.0"),
        .package(url: "https://github.com/musesum/MuSkyFlo.git", from: "0.23.0"),
    ],
    targets: [
        .target(
            name: "MuMenuSky",
            dependencies: [
                .product(name: "MuMenu", package: "MuMenu"),
                .product(name: "MuSkyFlo", package: "MuSkyFlo"),
                .product(name: "MuFlo", package: "MuFlo")],
            resources: [.process("Resources")]),
        .testTarget(
            name: "MuMenuSkyTests",
            dependencies: ["MuMenu","MuSkyFlo","MuFlo"]),
        
    ]
)
