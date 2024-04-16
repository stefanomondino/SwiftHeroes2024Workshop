import Foundation
import XCTest
@testable import Workshop

final class WorkshopTests: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2+2, 4)
    }
    
    struct TestRepository: TalkRepository {
        func talks() async throws -> [Workshop.Talk] {
            [.mockWithSpeaker, .mockWithoutSpeaker]
        }
    }
    
    func test_navigate_to_talk_detail() throws {
        let router = Router(container: .init())
        let viewModel = TalksScene.ViewModel(router: router,
                                             repository: TestRepository())
        expectRouteDefinition(on: viewModel,
                                  equalTo: TalkDetail.RouteDefinition(talk: .mockWithSpeaker)) { viewModel in
            viewModel.open(viewModel: .init(talk: .mockWithSpeaker))
        }
    }
}

extension Talk {
    static var mockWithSpeaker: Talk {
        .init(id: 1,
              code: "MOCK",
              title: "Test", abstract: "Test abstract",
              duration: 10,
              speakers: [.mock],
              room: .init(id: 1, name: "Name"),
              start: .init(timeIntervalSince1970: 100_000_000),
              end: .init(timeIntervalSince1970: 100_003_600))
    }
    static var mockWithoutSpeaker: Talk {
        .init(id: 1,
              code: "LUNCH",
              title: "Lunch", abstract: "Lunch time",
              duration: 10,
              speakers: [],
              room: .init(id: 1, name: "Name"),
              start: .init(timeIntervalSince1970: 100_010_000),
              end: .init(timeIntervalSince1970: 100_013_600))
    }
}

extension Speaker {
    static var mock: Speaker {
        .init(code: "MOCK", name: "Mock n roll", avatar: nil)
    }
}
