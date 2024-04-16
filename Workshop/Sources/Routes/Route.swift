import Foundation

/**
 A generic definition used to eventually create a `Route` by decoupling it from the underlying platform (ex: iOS vs macOS)

  # Discussion:
  A `RouteDefinition` object should contain all the parameters required to *navigate* somewhere in the app, without any concern about such navigation happens in practice.
  This should allow better testability and complete decoupling from the underlying platform inside agnostic objects like ViewModels or similar.

  # Example:
  ```swift
  struct ExampleDefinition: RouteDefinition {
     let name: String
  }
  ```
  > No reference to UIKit / SwiftUI / AppKit etc... should happen in `RouteDefinition` objects - Definitions should be platform agnostic.

  */
public protocol RouteDefinition {
    func isSameRoute(as other: RouteDefinition) -> Bool
}

public extension RouteDefinition where Self: Equatable {
    func isSameRoute(as other: RouteDefinition) -> Bool {
        if let other = other as? Self {
            self == other
        } else {
            false
        }
    }
}

public protocol EquatableRouteDefinition: Equatable, RouteDefinition {}

/**
 A generic protocol used by objects that implements *navigation* between screens or part of the app.
 It should be extended by subprotocols in platform-dedicated (example: `UIKitRoute`)
 */
public protocol Route {}

/**
 A `Route` concrete object that doesn't do anything. It's useful in situations where returning `nil` should be avoided
 */
public struct EmptyRoute: Route {
    public init() {}
}
