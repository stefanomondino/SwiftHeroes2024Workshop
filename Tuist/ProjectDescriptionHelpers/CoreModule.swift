//
//  CoreModel.swift
//  ProjectDescriptionHelpers
//
//  Created by Stefano Mondino on 17/04/24.
//

import Foundation
import ProjectDescription

public struct CoreModule {
    public let name: String
    public let dependencies: [TargetDependency]
    public let coreModules: [CoreModule]
    public init(
        name: String,
        dependencies: [TargetDependency] = [],
        coreModules: [CoreModule] = []
    ) {
        self.name = name
        self.dependencies = dependencies
        self.coreModules = coreModules
    }
    
    public func target() -> Target {
        .target(
            name: name.upperFirst,
            destinations: Set(
                Destination.allCases
            ),
            product: .framework,
            bundleId: "io.tuist.\(name.lowercased())",
            deploymentTargets: Constants.deploymentTargets,
            sources:  [.glob(
                "Workshop/Sources/\(name.upperFirst)/**"
            )],
            dependencies: dependencies + coreModules.map { $0.targetDependency() }
        )
    }
    
    public func targetDependency() -> TargetDependency {
        .target(name: name.upperFirst)
    }
}

extension CoreModule {
    public static var logger: CoreModule {
        .init(name: "Logger")
    }
    public static var networking: CoreModule {
        .init(name: "Networking", coreModules: [.logger])
    }
    public static var dependencyContainer: CoreModule {
        .init(name: "DependencyContainer", coreModules: [])
    }
}
