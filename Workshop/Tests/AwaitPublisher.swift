import Combine
import XCTest

public extension XCTestCase {
    func awaitPublisher<T: Publisher>(_ publisher: T,
                                      timeout: TimeInterval = 0.3,
                                      file: StaticString = #file,
                                      line: UInt = #line,
                                      trigger: () throws -> Void = {}) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = expectation(description: "Awaiting publisher")

        let cancellable = publisher.prefix(1)
            .sink(receiveCompletion: { completion in
                      switch completion {
                      case let .failure(error):
                          result = .failure(error)
                      case .finished:
                          break
                      }

                      expectation.fulfill()
                  },
                  receiveValue: { value in
                      result = .success(value)
                  })
        try trigger()

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered AppError at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
