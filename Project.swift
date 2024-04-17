import ProjectDescription
import ProjectDescriptionHelpers

let coreModules: [CoreModule] =
[
    .logger,
    .networking,
    .dependencyContainer
]
    
let excludedGlobs = coreModules.map { $0.name }.joined(separator: ",")

let targets: [Target] = [
    .target(
        name: "Workshop",
        destinations: .iOS,
        product: .app,
        bundleId: "io.tuist.Workshop",
        deploymentTargets: Constants.deploymentTargets,
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
                            "Workshop/Sources/{\(excludedGlobs)}/**",
                                    "Workshop/Sources/**/{*.macOS,*.watchOS,*.tvOS,*.visionOS}/*.swift"
                                    ],
                        compilationCondition: .when([.ios]))],
        
        resources: [.glob(pattern: "Workshop/Resources/**",
                          excluding: [
                            "Workshop/Resources/Fonts/**/*.txt",
                                      "Workshop/Resources/**/{*.tvOS,*.watchOS,*.macOS,*.visionOS}/*"
                                      ],
                          inclusionCondition: .when([.ios]))],
        
        dependencies: [
        .external(name: "MarkdownUI")] +
        coreModules.map { $0.targetDependency() }
    ),
    .target(
        name: "WorkshopTests",
        destinations: .iOS,
        product: .unitTests,
        bundleId: "io.tuist.WorkshopTests",
        infoPlist: .default,
        sources: ["Workshop/Tests/**"],
        resources: [],
        dependencies: [.target(name: "Workshop")]
    )] +
    coreModules.map { $0.target() }


let project = Project(
    name: "Workshop",
    targets: targets,
    resourceSynthesizers: [.fonts(), .assets(), .strings()]
)
