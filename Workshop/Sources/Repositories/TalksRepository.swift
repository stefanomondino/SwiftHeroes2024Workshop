//
//  TalksRepository.swift
//  Workshop
//
//  Created by Stefano Mondino on 05/04/24.
//

import Foundation
import Networking

protocol TalkRepository {
    func talks() async throws -> [Talk]
}


struct TalkRepositoryImplementation: TalkRepository {

    enum Endpoints {
        static func schedule() -> CodableEndpoint<Schedule> {
            .init(baseURL: AppEnvironment.shared.baseURL,
                  path: "")
        }
    }
    
    let rest: RESTDataSource
    init(rest: RESTDataSource) {
        self.rest = rest
    }
    
    func talks() async throws -> [Talk] {
        let schedule = try await rest.getCodable(at: Endpoints.schedule())
        
        let speakers = schedule.speakers.reduce(into: [Speaker.Code: Speaker]()) {
            $0[$1.code] = $1
        }
        
        let rooms = schedule.rooms.reduce(into: [Room.ID: Room]()) {
            $0[$1.id] = $1
        }
        
        let talks = schedule.talks.map { talk in
            Talk(id: talk.id,
                 code: talk.code,
                 title: talk.title.description,
                 abstract: talk.abstract?.description,
                 duration: talk.duration,
                 speakers: talk.speakers?.compactMap { speakers[$0] } ?? [],
                 room: rooms[talk.room],
                 start: talk.start?.date,
                 end: talk.end?.date)
        }
        
        return talks
    }
}
