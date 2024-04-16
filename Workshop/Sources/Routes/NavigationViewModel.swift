//
//  NavigationViewModel.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 07/03/24.
//

import Foundation

public struct BackMode: ExpressibleByStringInterpolation, Hashable {
    let value: String

    public init(_ value: StringLiteralType) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    public static var none: Self { "none" }
    public static var back: Self { "back" }
    public static var close: Self { "close" }
}

public protocol NavigationViewModel: ViewModel {
    var router: Router { get }
    var backMode: BackMode { get set }
}

public protocol ViewModel: ObservableObject {}
