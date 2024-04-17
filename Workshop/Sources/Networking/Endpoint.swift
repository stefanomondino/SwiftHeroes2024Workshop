import Foundation
import Logger

public struct Endpoint {
    public enum AuthorizationType: Equatable {
        case none
        case bearer
        case basic(username: String, password: String)
        case custom(String)
    }

    public enum Encoding {
        case json
        case form
        case custom(String)
    }

    public let baseURL: URL
    public let path: String
    public let parameters: BodyParameters
    public let queryParameters: [String: CustomStringConvertible]?
    public let httpMethod: HTTPMethod
    public let headers: [String: String]?
//    public let cacheTime: TimeInterval
    public let sampleData: Data
    public let authorization: AuthorizationType
    public let encoding: Encoding
    public let isRefreshEndpoint: Bool
    public let fileNameInBundle: String?
    public var cacheKey: String {
        [baseURL.absoluteString, path, httpMethod.rawValue,
         (parameters
             .jsonObject ?? [:])
             .merging(queryParameters ?? [:], uniquingKeysWith: { first, _ in first })
             .map { [$0.key, ($0.value as? CustomStringConvertible)?.description]
                 .compactMap { $0 }.joined(separator: "_")
             }
             .sorted()
             .joined()].joined()
    }

    public init(baseURL: URL,
                path: String,
                parameters: BodyParameters = [String: Any](),
                queryParameters: [String: CustomStringConvertible]? = nil,
                encoding: Encoding = .json,
                method: HTTPMethod = .get,
                headers: [String: String]? = nil,
//                cacheTime: TimeInterval = 0,
                fileNameInBundle: String? = nil,
                authorizationType: AuthorizationType = .none,
                mockedData: Data = Data(),
                isRefreshEndpoint: Bool = false) {
        self.baseURL = baseURL
        self.path = path
        self.isRefreshEndpoint = isRefreshEndpoint
        self.parameters = parameters
        self.queryParameters = queryParameters
        httpMethod = method
        self.headers = headers
        self.fileNameInBundle = fileNameInBundle
        sampleData = mockedData
        authorization = authorizationType
        self.encoding = encoding
    }
}

extension Endpoint: EndpointConvertible {
    public var endpoint: Endpoint { self }
}

public extension EndpointConvertible {
    var cacheKey: String { endpoint.cacheKey }
}

public protocol EndpointConvertible {
    var endpoint: Endpoint { get }
}

public enum HTTPMethod: String {
    /// `CONNECT` method.
    case connect = "CONNECT"
    /// `DELETE` method.
    case delete = "DELETE"
    /// `GET` method.
    case get = "GET"
    /// `HEAD` method.
    case head = "HEAD"
    /// `OPTIONS` method.
    case options = "OPTIONS"
    /// `PATCH` method.
    case patch = "PATCH"
    /// `POST` method.
    case post = "POST"
    /// `PUT` method.
    case put = "PUT"
    /// `TRACE` method.
    case trace = "TRACE"
}

public struct CodableEndpoint<Entity: Decodable>: EndpointConvertible {
    public init(_ endpoint: Endpoint,
                decoder: JSONDecoder = .init()) {
        self.endpoint = endpoint
        self.decoder = decoder
    }

    public init(baseURL: URL,
                path: String,
                parameters: BodyParameters = [String: Any](),
                queryParameters: [String: CustomStringConvertible]? = nil,
                encoding: Endpoint.Encoding = .json,
                method: HTTPMethod = .get,
                headers: [String: String]? = nil,
                fileNameInBundle: String? = nil,
                authorizationType: Endpoint.AuthorizationType = .none,
                mockedData: Data = Data(),
                isRefreshEndpoint: Bool = false,
                decoder: JSONDecoder = .init()) {

        self.init(Endpoint(baseURL: baseURL,
                    path: path,
                    parameters: parameters,
                    queryParameters: queryParameters,
                    encoding: encoding,
                    method: method,
                    headers: headers,
                    fileNameInBundle: fileNameInBundle,
                    authorizationType: authorizationType,
                    mockedData: mockedData,
                    isRefreshEndpoint: isRefreshEndpoint),
                  decoder: decoder)
    }
    
    public let decoder: JSONDecoder
    public let endpoint: Endpoint
}

public typealias JSON = [String: Any]

public protocol BodyParameters {
    var jsonObject: JSON? { get }
    var jsonArray: [JSON]? { get }
}

extension Dictionary: BodyParameters where Key == String {
    public var jsonObject: JSON? { self }
    public var jsonArray: [JSON]? { nil }
}

extension [JSON]: BodyParameters {
    public var jsonObject: JSON? {
        nil
    }

    public var jsonArray: [JSON]? {
        self
    }
}

public extension BodyParameters where Self: Encodable {
    var jsonObject: JSON? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return object
        } catch {
            Logger.log(error)
            return nil
        }
    }

    var jsonArray: [JSON]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let objects = try JSONSerialization.jsonObject(with: data, options: []) as? [JSON]
            return objects
        } catch {
            Logger.log(error)
            return nil
        }
    }
}

extension URLRequest {
    func cURL() -> String {
        let request = self
        guard let url = request.url else {
            return "Failed to get URL from request."
        }

        var curlCommand = "curl -v \\\n"

        // Add HTTP method
        if let httpMethod = request.httpMethod {
            curlCommand += " -X \(httpMethod) \\\n"
        }

        // Add headers
        if let allHeaders = request.allHTTPHeaderFields {
            for (key, value) in allHeaders {
                curlCommand += " -H '\(key): \(value)' \\\n"
            }
        }

        // Add request body, if any
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            curlCommand += " -d '\(bodyString)' \\\n"
        }

        // Add URL
        curlCommand += " \(url.absoluteString)"

        return curlCommand
    }
}
