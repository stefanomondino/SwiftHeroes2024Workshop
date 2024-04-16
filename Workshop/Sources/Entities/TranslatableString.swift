//
//  TranslatableString.swift
//  Workshop
//
//  Created by Stefano Mondino on 07/04/24.
//

import Foundation

struct TranslatableString: Codable, CustomStringConvertible, ExpressibleByStringInterpolation, Equatable {
    private let values: [String: String]
    private static var defaultCulture = "en"
    var description: String {
        values["en"] ?? ""
    }
    init(stringLiteral value: String) {
        self.values = [Self.defaultCulture: value]
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.values = try container.decode([String : String].self)
        } catch {
            let value = try container.decode(String.self)
            self.values = [Self.defaultCulture: value]
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.values)
    }
}
