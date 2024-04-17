//
//  Target+Helpers.swift
//  Config
//
//  Created by Stefano Mondino on 17/04/24.
//

import ProjectDescription

extension String {
    var upperFirst: String {
        String(self.prefix(1).uppercased() + self.dropFirst())
    }
}
