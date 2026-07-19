// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "otp_pin_field",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "otp-pin-field",
            targets: ["otp_pin_field"]
        )
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "otp_pin_field",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
