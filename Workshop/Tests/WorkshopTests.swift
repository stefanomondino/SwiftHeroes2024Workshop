import Foundation
import XCTest
@testable import Workshop

final class WorkshopTests: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2+2, 4)
    }
    
    struct TestRepository: TalkRepository {
        func talks() async throws -> [Workshop.Talk] {
            [.mock]
        }
    }
    
    func test_navigate_to_detail() throws {
        let router = Router(container: .init())
        let viewModel = TalksScene.ViewModel(router: router,
                                             repository: TestRepository())
        expectRouteDefinition(on: viewModel,
                                  equalTo: TalkDetail.RouteDefinition(talk: .mock)) { viewModel in
            viewModel.open(viewModel: .init(talk: .mock))
        } 
    }
}

extension Talk {
    static var mock: Talk {
        .init(id: 1,
              code: "MOCK",
              title: "Test", abstract: "Test abstract",
              duration: 10,
              speakers: [],
              room: nil,
              start: nil,
              end: nil)
    }
}
