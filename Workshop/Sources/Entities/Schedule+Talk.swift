//
//  Schedule+Talk.swift
//  Workshop
//
//  Created by Stefano Mondino on 08/04/24.
//

import Foundation

extension Schedule {
    struct Date: Codable {
        let date: Foundation.Date?
        init(from decoder: any Decoder) throws {
            let value = try decoder.singleValueContainer().decode(String.self)
            let formatter = ISO8601DateFormatter()
            self.date = formatter.date(from: value)
        }
        
    }
    struct Talk: Codable {
        
        typealias ID = Int
        typealias Code = String
        
        let id: ID
        let code: Code?
        let title: TranslatableString
        let abstract: TranslatableString?
        let duration: Int?
        let speakers: [Speaker.Code]?
        let room: Room.ID
        let start: Date?
        let end: Date?
    }
}
