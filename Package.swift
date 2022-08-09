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
        .package(url: "https://github.com/musesum/Tr3.git", from: "0.2.33"),
        .package(url: "https://github.com/musesum/MuMenu.git", from: "0.1.3"),
    ],
    targets: [
        .target(
            name: "MuMenuSky",
            dependencies: ["MuMenu","Tr3"]),
        .testTarget(
            name: "MuMenuSkyTests",
            dependencies: ["MuMenu","Tr3"]),
    ]
)
