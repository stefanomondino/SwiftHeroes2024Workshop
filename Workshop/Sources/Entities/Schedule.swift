//
//  Schedule.swift
//  Workshop
//
//  Created by Stefano Mondino on 07/04/24.
//

import Foundation

struct Schedule: Codable {
    let talks: [Talk]
    let rooms: [Room]
    let speakers: [Speaker]
}
