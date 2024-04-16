//
//  AppContainer+Routes.swift
//  Workshop
//
//  Created by Stefano Mondino on 10/04/24.
//

import Foundation
import UIKit

extension AppContainer {
    func setupRoutes() {
        
        register(for: Router.Container.self, scope: .singleton) { [self] in .init(container) }

        register(for: Router.self) {
            [self] in .init(container: unsafeResolve()) }
        let routerContainer = unsafeResolve(Router.Container.self)
        
        routerContainer.register(for: Router.Restart.self) { [self] _ in
            RestartRoute { [self] in
                let talks = TalksScene.Controller(viewModel: .init(router: .init(container: unsafeResolve()),
                                                                        repository: unsafeResolve()))
                return UINavigationController(rootViewController: talks)
            }
        }
        
        routerContainer.register(for: TalkDetail.RouteDefinition.self) { [self] definition in
            NavigationRoute { [self] in
                let viewModel = TalkDetail.ViewModel(definition.talk, router: .init(container: unsafeResolve()))
                return TalkDetail.Controller(viewModel: viewModel)
            }
        }
    }
}
