//
//  RestartRoute.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 05/03/24.
//

import Foundation
import UIKit

/**
 A `Route` used to restart the app by recreating the key `UIWindow`
 */
public struct RestartRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    public init(createViewController: @escaping () -> UIViewController) {
        self.createViewController = createViewController
    }

    public func execute(from viewController: UIViewController?) {
        let scene = viewController ?? UIApplication.shared.delegate?.window??.rootViewController

        if let presented = scene?.presentedViewController {
            execute(from: presented)
            return
        }

        if let presenting = scene?.presentingViewController {
            scene?.dismiss(animated: false) {
                execute(from: presenting)
            }
            return
        }

        (scene?.view.window?.windowScene?.delegate as? WindowContainer)?
            .recreateWindow(with: createViewController())
    }
}
