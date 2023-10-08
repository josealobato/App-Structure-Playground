// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UsersCollection",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UsersCollection",
            targets: ["UsersCollection"]),
    ],
    dependencies: [
        .package(name: "JToolKit", path: "../JToolKit"),
        .package(name: "Entities", path: "../Entities"),
        .package(name: "Coordinator", path: "../Coordinator")
    ],
    targets: [
        .target(
            name: "UsersCollection",
            dependencies: ["JToolKit", "Entities", "Coordinator"]),
        .testTarget(
            name: "UsersCollectionTests",
            dependencies: ["UsersCollection", "Entities", "Coordinator"]),
    ]
)
