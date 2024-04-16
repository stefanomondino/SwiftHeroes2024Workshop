//
//  Logger+Levels.swift
//  Core
//
//  Created by Stefano Mondino on 15/11/20.
//

import Foundation

public extension Logger {
    struct Level: RawRepresentable, Comparable, ExpressibleByNilLiteral, Hashable {
        public init(nilLiteral: ()) {
            self = .none
        }
        
        public typealias Value = Double
        public let rawValue: Value
        private static let maximumAvailableNumber = 100_000_000.0
        
        public var stringValue: String {
            switch rawValue {
            case Logger.Level.verbose.rawValue:
                return "Verbose"
            case Logger.Level.default.rawValue:
                return "Default"
            case Logger.Level.warning.rawValue:
                return "Warning"
            case Logger.Level.error.rawValue:
                return "Error"
            case Logger.Level.none.rawValue:
                return "None"
            default:
                return "Unknown"
            }
        }
        
        public static var none: Self { .init(maximumAvailableNumber) }
        public static var verbose: Self { .init(0) }
        public static var `default`: Self { .init(1) }
        public static var warning: Self { between(.default, and: .none) }
        public static var error: Self { between(.warning, and: .none) }

        public static func between(_ min: Self, and max: Self = .none) -> Self {
            .init((min.rawValue + max.rawValue) / 2.0)
        }

        public init(_ value: Value) {
            self = .init(rawValue: value)
        }

        public init(rawValue: Value) {
            self.rawValue = min(rawValue, Self.maximumAvailableNumber)
        }

        public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
