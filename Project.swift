import ProjectDescription

let project = Project(
    name: "Workshop",
    targets: [
        .target(
            name: "Workshop",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Workshop",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest":
                        ["UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [[
                                "UISceneClassName": "UIWindowScene",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]]
                        ]]
                ]
            ),
            sources: [.glob("Workshop/Sources/**",
                            excluding: [
                                // "Workshop/Sources/{DependencyContainer}/**",
                                        "Workshop/Sources/**/{*.macOS,*.watchOS,*.tvOS,*.visionOS}/*.swift"
                                        ],
                            compilationCondition: .when([.ios]))],
            
            resources: [.glob(pattern: "Workshop/Resources/**",
                              excluding: [
                                "Workshop/Resources/Fonts/**/*.txt",
                                          "Workshop/Resources/**/{*.tvOS,*.watchOS,*.macOS,*.visionOS}/*"
                                          ])],
            
            dependencies: [
                // .target(name: "DependencyContainer"),
            .external(name: "MarkdownUI")]
        ),
        // .target(
        //     name: "Workshop_macOS",
        //     destinations: .macOS,
        //     product: .app,
        //     bundleId: "io.tuist.Workshop",
        //     deploymentTargets: .macOS("14.0"),
        //     infoPlist: .extendingDefault(
        //         with: [
        //             :
        //         ]
        //     ),
        //     sources: [.glob("Workshop/Sources/**",
        //                     excluding: ["Workshop/Sources/{DependencyContainer}/**",
        //                                 "Workshop/Sources/**/{*.tvOS,*.watchOS,*.iOS,*.visionOS}/*.swift"],
        //                     compilationCondition: .when([.macos]))],
            
        //     resources: [.glob(pattern: "Workshop/Resources/**", 
        //                       excluding: ["Workshop/Resources/Fonts/**/*.txt",
        //                                  "Workshop/Resources/**/{*.tvOS,*.watchOS,*.iOS,*.visionOS}/*"])],
            
        //     dependencies: [.target(name: "DependencyContainer")]
        // ),
        // .target(
        //     name: "DependencyContainer",
        //     destinations: Set(Destination.allCases),
        //     product: .framework,
        //     bundleId: "io.tuist.dependencyContainer",
        //     deploymentTargets: .multiplatform(iOS: "17.0", macOS: "14.0"),
        //     sources: [.glob("Workshop/Sources/DependencyContainer/**")],
        //     dependencies: []
        // ),
    
        .target(
            name: "WorkshopTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.WorkshopTests",
            infoPlist: .default,
            sources: ["Workshop/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Workshop")]
        ),
    ],
    resourceSynthesizers: [.fonts(), .assets(), .strings()]
)
