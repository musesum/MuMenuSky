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
        .package(url: "https://github.com/musesum/MuSky.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "MuMenuSky",
            dependencies: [
                .product(name: "MuMenu", package: "MuMenu"),
                .product(name: "MuSky", package: "MuSky"),
                .product(name: "Tr3", package: "Tr3")],
            resources: [.process("Resources")]),
        .testTarget(
            name: "MuMenuSkyTests",
            dependencies: ["MuMenu","MuSky","Tr3"]),
        
    ]
)
