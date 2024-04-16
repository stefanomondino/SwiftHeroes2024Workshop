//
//  TalkDetail.swift
//  Workshop
//
//  Created by Stefano Mondino on 08/04/24.
//

import Foundation

struct TalkDetail {
    class ViewModel: NavigationViewModel {
        var router: Router
        
        var backMode: BackMode
        @Published var title: String
        @Published var abstract: String
        @Published var speakers: [SpeakerViewModel]
        private let talk: Talk
        init(_ talk: Talk,
             router: Router,
             backMode: BackMode = .back) {
            self.router = router
            self.backMode = backMode
            self.talk = talk
            self.title = talk.title
            self.abstract = talk.abstract ?? ""
            self.speakers = talk.speakers.map { .init(speaker: $0) }
        }
    }
}
