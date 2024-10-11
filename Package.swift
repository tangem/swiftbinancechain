// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "BinanceChain",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(name: "BinanceChain", targets: ["BinanceChain"])
    ],
    dependencies: [
        .package(url: "https://github.com/tangem/swift-protobuf-binaries.git", exact: "1.25.2-tangem1"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "BinanceChain",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf-binaries"),
                "Alamofire",
                "SwiftyJSON",
                "SwiftDate",
            ],
            path: "BinanceChain/Sources"
        ),
    ]
)
