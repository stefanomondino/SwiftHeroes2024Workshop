//
//  App.swift
//  Workshop
//
//  Created by Stefano Mondino on 10/04/24.
//

import Foundation
import SwiftUI

@main
struct App: SwiftUI.App {
    @State var appContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            TalksScene.View(viewModel: appContainer.rootViewModel)
        }
    }
}
