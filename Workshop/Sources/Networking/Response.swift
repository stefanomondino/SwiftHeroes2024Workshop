import Foundation
import Logger

public struct Response {
    struct InternalError: Swift.Error {}

    public init(code: NetworkingError.Code, data: Data) {
        self.code = code
        originalData = data
    }

    public let code: NetworkingError.Code
    private let originalData: Data

    public func data() throws -> Data {
        if code.isOK {
            return originalData
        } else {
            throw NetworkingError(code, underlyingError: InternalError())
        }
    }

    public func codable<Entity: Decodable>(decoder: JSONDecoder) throws -> Entity {
        do {
            return try decoder.decode(Entity.self, from: data())
        } catch {
            Logger.log(error, level: .error)
            throw NetworkingError.jsonMapping(error)
        }
    }
}
