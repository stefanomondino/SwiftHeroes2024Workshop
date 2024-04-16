//
//  SceneViewController.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 07/03/24.
//

import Combine
import Foundation
import SwiftUI
import UIKit

open class SceneViewController<View: SceneView>: UIHostingController<View> {
    public let viewModel: View.ViewModel
    public var cancellables = [AnyCancellable]()

    private let isActive: PassthroughSubject<Bool, Never> = .init()

    public init(viewModel: View.ViewModel) {
        self.viewModel = viewModel
        super.init(rootView: .init(viewModel: viewModel))
    }

    @available(*, unavailable)
    @objc public dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = viewModel

        subscribe(to: viewModel.router).store(in: &cancellables)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isActive.send(true)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isActive.send(true)
        if let navigation = navigationController,
           navigation.topViewController == self {
            viewModel.backMode = navigation.viewControllers.count > 1 ? .back : .none
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isActive.send(false)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isActive.send(false)
    }
}
