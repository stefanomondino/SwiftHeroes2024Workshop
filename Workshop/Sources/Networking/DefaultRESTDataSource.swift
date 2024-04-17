import Foundation
import Logger

extension Logger.Level {
    static var network: Self = .init(20)
}

public class DefaultRESTDataSource: RESTDataSource {
    /// A local cache storing ongoing tasks to avoid multiple api calls to the same endpoint at the same time
    internal actor RequestCache {
        private var cache: [URLRequest: Task<Response, Error>] = [:]

        func clear(for request: URLRequest) async {
            cache[request] = nil
        }

        func set(_ task: Task<Response, Error>, for request: URLRequest) async {
            cache[request] = task
        }
        
        func get(for request: URLRequest) async -> Task<Response, Error>? {
            cache[request]
        }
    }
    
    static private var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = .shared
        configuration.httpMaximumConnectionsPerHost = 8
        return URLSession(configuration: configuration)
    }()
    
    private let session: URLSession
    
    private var requestCache: RequestCache = .init()
    
    public required init(session: URLSession? = nil) {
        self.session = session ?? Self.defaultSession
    }
    
    func response(at endpoint: EndpointConvertible) async throws -> Response {

        do {
            return try await responseDataTask(for: endpoint)
            
        } catch let error as NetworkingError {
            if error.code == .httpUnauthorized,
               !endpoint.endpoint.isRefreshEndpoint,
               endpoint.endpoint.authorization == .bearer {
                try await refreshToken()
                return try await response(at: endpoint)
            }
            throw error
        } catch {
            throw NetworkingError.unknown(error)
        }
    }
    
    public func getCodable<Result: Decodable>(at endpoint: CodableEndpoint<Result>) async throws -> Result {
        try await response(at: endpoint.endpoint)
            .codable(decoder: endpoint.decoder)
    }
    
    public func getData(at endpoint: any EndpointConvertible) async throws -> Data {
        try await response(at: endpoint.endpoint)
            .data()
    }
    
    public func request(for endpoint: any EndpointConvertible) -> URLRequest? {
        try? dataRequest(for: endpoint)
    }
}

extension DefaultRESTDataSource {
    
    private func setAuthorizationHeaders(for headers: inout [String: String],
                                         endpoint: Endpoint) throws {
        switch endpoint.authorization {
        case let .basic(username, password):
            let base64 = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
            headers["Authorization"] = "Basic \(base64)"
        case .bearer:
            // implement here automatic access token logic - out of scope for this project :)
            throw NetworkingError(.httpUnauthorized)
        case let .custom(string): headers["Authorization"] = string
        case .none: break
        }
    }
    
    func dataRequest(for endpoint: EndpointConvertible) throws -> URLRequest? {
        let endpoint = endpoint.endpoint
        var headers = endpoint.headers ?? [:]
        try setAuthorizationHeaders(for: &headers, endpoint: endpoint)
        
        guard var components = URLComponents(url: endpoint.baseURL,
                                             resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.path = "/" + (components.path + "/" + endpoint.path)
            .components(separatedBy: "/")
            .filter { !$0.isEmpty }
            .joined(separator: "/")
        if endpoint.path.reversed().starts(with: "/"),
           !components.path.reversed().starts(with: "/") {
            components.path += "/"
        }
        let queryItems: [URLQueryItem] = (components.queryItems ?? []) + (endpoint.queryParameters ?? [:])
            .sorted(by: { first, second in
                first.key < second.key
            })
            .map { .init(name: $0.key, value: $0.value.description) }
        
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        if endpoint.httpMethod != .get {
            switch endpoint.encoding {
            case .form:
                var components = URLComponents()
                components.queryItems = endpoint.parameters.jsonObject?
                    .map { key, value in
                        URLQueryItem(name: key, value: "\(value)")
                    }
                if let body = components.percentEncodedQuery?.data(using: .utf8) {
                    urlRequest.httpBody = body
                    headers["Content-Type"] = "application/x-www-form-urlencoded"
                }
                
            case .json:
                if let body: Any = (endpoint.parameters.jsonObject ?? endpoint.parameters.jsonArray) {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
                    headers["Content-Type"] = "application/json"
                }
            case let .custom(encoding):
                headers["Content-Type"] = encoding
            }
        }
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

private extension DefaultRESTDataSource {
    
    func responseDataTask(for endpoint: EndpointConvertible) async throws -> Response {
        
        guard let request = try? dataRequest(for: endpoint) else {
            throw NetworkingError.generic
        }

        let task = Task(priority: .utility) {
            
            do {
                let (data, response) = try await session.data(for: request)
                Logger.log(response, level: .network)
                
                let code = NetworkingError.Code((response as? HTTPURLResponse)?.statusCode ?? -1)
                Logger.log(String(data: data, encoding: .utf8) ?? "", level: .verbose)
                await requestCache.clear(for: request)
                return Response(code: code, data: data)
                
            } catch {
                await requestCache.clear(for: request)
                throw NetworkingError.unknown(error)
            }
        }
        
        await requestCache.set(task, for: request)
        return try await task.value
    }
    
    private func refreshToken() async throws {
        // implement here any custom refresh token logic
        throw NetworkingError.cancelled
    }
}
