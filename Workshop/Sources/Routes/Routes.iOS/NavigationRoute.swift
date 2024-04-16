import Foundation
import UIKit

public struct NavigationRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    
    public init(createViewController: @escaping () -> UIViewController) {
        self.createViewController = createViewController
    }

    public func execute(from scene: (some UIViewController)?) {
        

        if let navigation = scene?.navigationController,
           let destination = createViewController() {
        
            navigation.pushViewController(destination,
                           animated: true)
        }
    }
}
