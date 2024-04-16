import Foundation

public protocol RESTDataSource: AnyObject {
    func request(for endpoint: EndpointConvertible) -> URLRequest?
    func getCodable<Result: Decodable>(at endpoint: CodableEndpoint<Result>) async throws -> Result
    func getData(at endpoint: EndpointConvertible) async throws -> Data
}

public protocol MockableRESTDataSource: RESTDataSource {

    func removeMock(at endpoint: EndpointConvertible)
    func mockJSONString(_ jsonString: String,
                        statusCode: NetworkingError.Code,
                        for key: EndpointConvertible)
    func mockJSONFile(_ path: String,
                      bundle: Bundle,
                      statusCode: NetworkingError.Code,
                      for key: EndpointConvertible)
}


public extension RESTDataSource {
    func getCodable<Result: Decodable>(at endpoint: EndpointConvertible,
                                       type _: Result.Type) async throws -> Result {
        try await getCodable(at: CodableEndpoint<Result>(endpoint.endpoint))
    }

    func getCodable<Result: Decodable>(at endpoint: EndpointConvertible) async throws -> Result {
        try await getCodable(at: CodableEndpoint<Result>(endpoint.endpoint))
    }
}
