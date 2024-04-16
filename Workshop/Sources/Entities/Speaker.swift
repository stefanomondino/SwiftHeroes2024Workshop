//
//  Talk.swift
//  Workshop
//
//  Created by Stefano Mondino on 04/04/24.
//

import Foundation

struct Speaker: Codable, Equatable {
    typealias Code = String
    let code: Code
    let name: String
    let avatar: URL?
}
