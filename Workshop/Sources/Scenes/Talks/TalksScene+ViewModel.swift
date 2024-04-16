//
//  TalksViewController.swift
//  Workshop
//
//  Created by Stefano Mondino on 05/04/24.
//

import Foundation

struct TalksScene {
    
    class ViewModel: NavigationViewModel {
        var router: Router
        var backMode: BackMode = .none
        let repository: TalkRepository
        @Published var items: [TalkViewModel] = []
        init(router: Router,
             repository: TalkRepository) {
            self.router = router
            self.repository = repository
        }
        
        func reload() {
            Task { @MainActor in
                let talks = try await self.repository.talks()
                self.items = talks.map { TalkViewModel(talk: $0)}
            }
        }
        
        func open(viewModel: TalkViewModel) {
            let talk = viewModel.talk
            let route = TalkDetail.RouteDefinition(talk: talk)
            router.send(route)
        }
    }
}

