//
//  Navigation+Tests.swift
//  WorkshopTests
//
//  Created by Stefano Mondino on 16/04/24.
//

import Foundation
//import DependencyContainer
import Foundation
import XCTest
@testable import Workshop

extension XCTestCase {

    public func expectRouteDefinition(_ router: Router,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      equalTo otherRoute: RouteDefinition,
                                      trigger: () throws -> Void) rethrows {
        try expectRouteDefinition(router: router,
                                  file: file,
                                  line: line,
                                  trigger: trigger,
                                  expectation: { assertEqual($0, otherRoute) })
    }

    public func expectRouteDefinition<ViewModel: NavigationViewModel>(on viewModel: ViewModel,
                                                                      file: StaticString = #file,
                                                                      line: UInt = #line,
                                                                      equalTo otherRoute: RouteDefinition,
                                                                      trigger: (ViewModel) throws -> Void) rethrows {
        try expectRouteDefinition(router: viewModel.router,
                                  file: file,
                                  line: line,
                                  trigger: { try trigger(viewModel) },
                                  expectation: { assertEqual($0, otherRoute) })
    }

    public func expectRouteDefinition<ViewModel: NavigationViewModel>(on viewModel: ViewModel,
                                                                      file: StaticString = #file,
                                                                      line: UInt = #line,
                                                                      equalTo otherRouteIdentifier: Router.Identifier,
                                                                      trigger: (ViewModel) throws -> Void) rethrows {
        try expectRouteDefinition(router: viewModel.router,
                                  file: file,
                                  line: line,
                                  trigger: { try trigger(viewModel) },
                                  expectation: { assertEqual($0, otherRouteIdentifier.definition) })
    }

    public func expectRouteDefinition<RouteDefinition: Workshop.RouteDefinition>(_ viewModel: any NavigationViewModel,
                                                                               file: StaticString = #file,
                                                                               line: UInt = #line,
                                                                               trigger: () throws -> Void,
                                                                               expectation: (RouteDefinition) throws -> Void) rethrows {
        try expectRouteDefinition(router: viewModel.router,
                                  file: file,
                                  line: line,
                                  trigger: trigger,
                                  expectation: expectation)
    }

    public func expectRouteDefinition<Definition: Workshop.RouteDefinition>(router: Router,
                                                                          type definitionType: Definition.Type = Definition.self,
                                                                          file: StaticString = #file,
                                                                          line: UInt = #line,
                                                                          trigger: () throws -> Void,
                                                                          expectation: (Definition) throws -> Void) rethrows {
        guard let output = try? awaitPublisher(router.routes, trigger: trigger) else {
            XCTFail("No output from router after timeout", file: file, line: line)
            return
        }

        guard let route = try? XCTUnwrap(output as? Definition, file: file, line: line) else {
            XCTFail("Route definition of type \(type(of: output)) is not equal or conforming to expected type \(definitionType)",
                    file: file,
                    line: line)
            return
        }
        try expectation(route)
    }

    public func expectRouteDefinition(router: Router,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      trigger: () throws -> Void,
                                      expectation: (RouteDefinition) throws -> Void) rethrows {
        guard let route = try? awaitPublisher(router.routes, trigger: trigger) else {
            XCTFail("No output from router after timeout", file: file, line: line)
            return
        }
        try expectation(route)
    }

    public func expectRoute<Route: Workshop.Route>(_ id: Router.Identifier,
                                                   router: Router,
                                                 type routeType: Route.Type = Route.self,
                                                 file: StaticString = #file,
                                                 line: UInt = #line,
                                                 expectation: (Route) throws -> Void) rethrows {
        guard let output = router.resolve(id.definition) else {
            XCTFail("No route registered for \(id.definition)", file: file, line: line)
            return
        }
        guard let route = output as? Route else {
            XCTFail("Received route of type \(type(of: output)) is not equal or conforming to expected type \(routeType)",
                    file: file,
                    line: line)
            return
        }
        try expectation(route)
    }

    public func expectRoute<Route: Workshop.Route>(
        _ id: Router.Identifier,
        router: Router,
        type: Route.Type = Route.self,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expectRoute(id,
                    router: router,
                    type: type,
                    file: file,
                    line: line,
                    expectation: {
            _ in
        })
    }
}

public func assertEqual(
    _ route: RouteDefinition,
    _ otherRoute: RouteDefinition,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard route.isSameRoute(
        as: otherRoute
    ) else {
        XCTFail(
            "Route \(route) is not equal to \(otherRoute)",
            file: file,
            line: line
        )
        return
    }
}
