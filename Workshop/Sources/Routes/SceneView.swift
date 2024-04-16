//
//  SceneView.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 07/03/24.
//

import Foundation
import SwiftUI

public protocol SceneView: View {
    associatedtype ViewModel: NavigationViewModel
    var viewModel: ViewModel { get }
    init(viewModel: ViewModel)
}
