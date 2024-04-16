//
//  Logger+Tags.swift
//  Core
//
//  Created by Stefano Mondino on 15/11/20.
//

import Foundation

public extension Logger {
    struct Tag: CustomStringConvertible, Equatable, ExpressibleByStringInterpolation {
        public let description: String
        public init(stringLiteral value: String) {
            description = value
        }

        public static var none: Self { "" }
    }
}
