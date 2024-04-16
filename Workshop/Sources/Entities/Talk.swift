//
//  Talk.swift
//  Workshop
//
//  Created by Stefano Mondino on 04/04/24.
//

import Foundation

struct Talk: Codable, Equatable {
    typealias ID = Int
    typealias Code = String
    
    let id: ID
    let code: Code?
    let title: String
    let abstract: String?
    let duration: Int?
    let speakers: [Speaker]
    let room: Room?
    let start: Date?
    let end: Date?
}
