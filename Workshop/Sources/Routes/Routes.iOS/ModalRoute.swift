import Foundation
import UIKit

public struct ModalRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    let fullscreen: Bool
    let ignoreIf: (UIViewController?) -> Bool
    public init(fullscreen: Bool = false,
                ignoreIf: @escaping (UIViewController?) -> Bool = { _ in false },
                createViewController: @escaping () -> UIViewController) {
        self.fullscreen = fullscreen
        self.ignoreIf = ignoreIf
        self.createViewController = createViewController
    }

    public func execute(from scene: (some UIViewController)?) {
        if let presented = scene?.presentedViewController {
            execute(from: presented)
            return
        }
        if ignoreIf(scene) {
            return
        }

        if let destination = createViewController() {
            if fullscreen {
                destination.modalPresentationStyle = .fullScreen
            }

            scene?.present(destination,
                           animated: true)
        }
    }
}
