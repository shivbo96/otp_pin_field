// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "otp_pin_field",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "otp_pin_field",
            targets: ["otp_pin_field"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/flutter/packages.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "otp_pin_field",
            dependencies: [
                .product(name: "Flutter", package: "packages")
            ],
            path: "Classes"
        )
    ]
)
