//
//  SceneDelegate+Routes.swift
//  Services_iOS
//
//  Created by Stefano Mondino on 19/03/24.
//

import Combine
import Foundation
import UIKit

public protocol WindowContainer {
    func recreateWindow(with viewController: UIViewController?)
}

open class BaseSceneDelegate: UIResponder, UIWindowSceneDelegate, WindowContainer {
    public var window: UIWindow?

    private var cancellables: [AnyCancellable] = []
    open var router: Router { Router(container: .init()) }

    public func recreateWindow(with viewController: UIViewController?) {
        guard let windowScene = window?.windowScene, let viewController else {
            return
        }
        recreateWindow(with: windowScene, viewController: viewController)
    }

    public func scene(_ scene: UIScene,
                      willConnectTo _: UISceneSession,
                      options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        recreateWindow(with: windowScene, viewController: UIViewController())
        router.send(Router.restart())
        
    }

    open func restart() {}

    private func recreateWindow(with windowScene: UIWindowScene,
                                viewController: UIViewController) {
        cancellables = []
        window = UIWindow(windowScene: windowScene)

        window?.rootViewController = viewController
        window?.subscribe(to: router)
            .store(in: &cancellables)
        window?.makeKeyAndVisible()
    }
}
