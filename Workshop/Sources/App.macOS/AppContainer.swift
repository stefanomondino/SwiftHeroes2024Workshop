//
//  AppContainer.swift
//  Workshop
//
//  Created by Stefano Mondino on 05/04/24.
//

import Foundation
import DependencyContainer

class AppContainer: DependencyContainer {
    private(set) var container = ObjectContainer()
    lazy var router: Router = unsafeResolve()
    lazy var rootViewModel = TalksScene.ViewModel(router: .init(container: unsafeResolve()),
                                    repository: unsafeResolve())
    init() {
        setup()
    }
    
    func setup() {
        container = ObjectContainer()
        Logger.shared.add(logger: ConsoleLogger(logLevel: .verbose))
        
        register(for: RESTDataSource.self, scope: .singleton) {
            DefaultRESTDataSource()
        }
        
        register(for: TalkRepository.self, scope: .singleton) { [self] in
            TalkRepositoryImplementation(rest: unsafeResolve())
        }
        setupRoutes()
        
    }
}
