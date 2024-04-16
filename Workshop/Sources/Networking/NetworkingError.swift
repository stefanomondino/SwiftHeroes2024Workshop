import Foundation

public struct NetworkingError: Error, Equatable {
    public static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        lhs.code == rhs.code
    }

    public struct Code: ExpressibleByIntegerLiteral, CustomStringConvertible, Equatable {
        public let value: Int

        static var jsonMapping: Code { 10001 }
        static var generic: Code { 0 }

        public var description: String {
            switch self {
            case .jsonMapping: return "jsonMapping"
            case .generic: return "generic"
            default: return "\(value)"
            }
        }

        public init(_ value: Int) {
            self.value = value
        }

        public init(integerLiteral value: Int) {
            self.value = value
        }
    }

    public var code: Code
    public var underlying: Error?
    public init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        underlying = underlyingError
    }

    public static func unknown(_: Error) -> NetworkingError {
        .init(Code.httpServerError)
    }

    public static var generic: NetworkingError {
        .init(0)
    }

    public static var cancelled: NetworkingError {
        .init(-999)
    }

    public static func jsonMapping(_ error: Error? = nil) -> NetworkingError {
        .init(.jsonMapping, underlyingError: error)
    }
}

public extension NetworkingError.Code {
    static var httpOk: Self { 200 }
    static var httpClientError: Self { 400 }
    static var httpUnauthorized: Self { 401 }
    static var httpForbidden: Self { 403 }
    static var httpNotFound: Self { 404 }
    static var httpServerError: Self { 500 }
    var isOK: Bool {
        value < 400
    }
}
