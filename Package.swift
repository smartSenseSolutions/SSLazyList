// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSLazyList",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SSLazyList",
            targets: ["SSLazyList"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SSLazyList", exclude: ["iOS_Example",
                    "iOS_Example/Models",
                    "iOS_Example/Models/UserModel.swift",
                    "iOS_Example/Preview Content",
                    "iOS_Example/Preview Content/Preview Assets.xcassets",
                    "iOS_Example/Services",
                    "iOS_Example/Services/UserDataService.swift",
                    "iOS_Example/Assets.xcassets",
                    "iOS_Example/ContentView.swift",
                    "iOS_Example/iOS_Example.entitlements",
                    "iOS_Example/iOS_ExampleApp.swift",
                    "iOS_ExampleTests",
                    "iOS_ExampleTests/iOS_ExampleTests.swift",
                    "iOS_ExampleUITests",
                    "iOS_ExampleUITests/iOS_ExampleUITests.swift",
                    "iOS_ExampleUITests/iOS_ExampleUITestsLaunchTests.swift"]),

        .testTarget(
            name: "SSLazyListTests",
            dependencies: ["SSLazyList"]),
    ]
)
