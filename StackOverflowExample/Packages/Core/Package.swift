// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "TagsFeature", targets: ["TagsFeature"]),
        .library(name: "QuestionsFeature", targets: ["QuestionsFeature"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.34.0")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "APIClient",
                "TagsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/AppFeature"
        ),
        .target(
            name: "APIClient",
            dependencies: [],
            path: "Sources/APIClient"
        ),
        .target(
            name: "TagsFeature",
            dependencies: [
                "APIClient",
                "QuestionsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/TagsFeature"
        ),
        .target(
            name: "QuestionsFeature",
            dependencies: [
                "APIClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/QuestionsFeature"
        ),
    ]
)
