//
//  Room.swift
//  Workshop
//
//  Created by Stefano Mondino on 07/04/24.
//

import Foundation

struct Room: Codable, Equatable {
    typealias ID = Int
    let id: ID
    let name: TranslatableString
}
