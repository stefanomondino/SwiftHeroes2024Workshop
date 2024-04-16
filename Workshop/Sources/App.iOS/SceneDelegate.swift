import Foundation
import UIKit
import SwiftUI

final class SceneDelegate: BaseSceneDelegate {
    public var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Something went wrong - AppDelegate is not available from SceneDelegate")
        }
        return appDelegate
    }

    override var router: Router { appDelegate.appContainer.router }
}
