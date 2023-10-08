// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Repositories",
            targets: ["Repositories"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "JToolKit", path: "../JToolKit"),
        .package(url: "https://github.com/janodevorg/CoreDataStack", exact: "1.0.4"),
        .package(url: "https://github.com/rwbutler/connectivity", exact: "6.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Repositories",
            dependencies: [
                "JToolKit",
                .product(name: "CoreDataStack", package: "CoreDataStack"),
                .product(name: "Connectivity", package: "connectivity"),
            ]
        ),
        .testTarget(
            name: "RepositoriesTests",
            dependencies: ["Repositories"]),
    ]
)
