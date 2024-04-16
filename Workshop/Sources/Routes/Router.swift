import Combine
//import DependencyContainer

public struct Router {
    /**
            An object containing all the `Route` underlying implementations associated to a `RouteDefinition` type.

     This is slightly different compared to regular `ObjectContainer` and similar to
     `DependencyContainer` core framework because it's used to register closures returning `Route`
     and associate them to `RouteDefinition.Type` identifiers.
     */
    public class Container {
        fileprivate let container: ObjectContainer

        /// Initialize the custom `Container` object using a dependency container.
        /// - Parameters:
        ///     - container: an `ObjectContainer` use to register closures associated to object Types.
        public init(_ container: ObjectContainer = .init()) {
            self.container = container
        }

        /// Registers a specific association between a concrete `RouteDefinition` and a concrete `Route`
        /// - Parameters:
        ///     - definitionType: the type of the `RouteDefinition` object getting registered
        ///     - closure: a closure that will associate a concrete definition of given type to a concrete `Route`
        public func register<Definition: RouteDefinition>(for definitionType: Definition.Type,
                                                          closure: @escaping (Definition) -> Route) {
            container.register(for: ObjectIdentifier(definitionType),
                               handler: { closure })
        }
    }

    private let container: Container
    let routes: PassthroughSubject<RouteDefinition, Never> = .init()

    public init(container: Container = .init()) {
        self.container = container
    }

    public func send(_ route: RouteDefinition) {
        routes.send(route)
    }

    public func send(_ id: Identifier) {
        send(id.definition)
    }

    func resolve<Definition: RouteDefinition>(_ definition: Definition) -> Route? {
        guard let handler: (Definition) -> Route = container.container.resolve(ObjectIdentifier(Definition.self)) else {
            Logger.log("Route not found: \(definition)", level: .warning, tag: .routes)
            return nil
        }
        return handler(definition)
    }
}

public extension Router {
    /// A support object used to easily retrieve route definitions in `Router.send` function.
    ///
    /// > Behavior is automatically extended by a Sourcery template, with a 1to1 mapping between every `Router.RouteDefinition`
    /// static func or variable and same function on `Identifier` object

    struct Identifier {
        let definition: RouteDefinition
        public init(_ definition: RouteDefinition) {
            self.definition = definition
        }
    }
}

public extension Logger.Tag {
    static var routes: Self { "Routes" }
}
