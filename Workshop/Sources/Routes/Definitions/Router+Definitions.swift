//
//  Router+Definitions.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 04/03/24.
//

import Foundation

public extension Router {
    struct Restart: RouteDefinition, Equatable {
        public init() {}
    }

    struct None: RouteDefinition, Equatable {
        public init() {}
    }
}

public extension Router {
    static func restart() -> RouteDefinition { Restart() }
}
