//
//  UIViewController+Routes.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 04/03/24.
//

import Combine
import Foundation
import UIKit

public protocol UIKitRoute: Route {
    /**
     Executes the route using given `viewController` as source.
     - Parameters:
        - viewController: The starting `UIViewController` to execute the route with.
     */
    func execute(from viewController: UIViewController?)
}

public extension UIViewController {
    /**
        Subscribes current view controller to given `Router` so that every time a compatible `Route` is emitted it gets executed.

        > `UIViewController` is compatible with any `Route` conforming to `UIKitRoute`; any other type of Route will be ignored.

     - Parameters:
            - router: A router emitting routes. Every `Route` not conforming to `UIKitRoute` is ignored.
     - Returns:
        A `AnyCancellable` object that will keep the binding alive until it gets explicitly cancelled.
     */
    func subscribe(to router: Router) -> AnyCancellable {
        router.routes
            .compactMap { router.resolve($0) as? UIKitRoute }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                route.execute(from: self)
            }
    }
}

public extension UIWindow {
    func subscribe(to router: Router) -> AnyCancellable {
        router.routes
            .compactMap { router.resolve($0) as? UIKitRoute }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                route.execute(from: self?.rootViewController)
            }
    }
}
