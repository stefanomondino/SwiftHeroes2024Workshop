//
//  TalkDetail+Route.swift
//  WorkshopTests
//
//  Created by Stefano Mondino on 16/04/24.
//

import Foundation

extension TalkDetail {
    struct RouteDefinition: EquatableRouteDefinition {
        let talk: Talk
        init(talk: Talk) {
            self.talk = talk
        }
    }
}
