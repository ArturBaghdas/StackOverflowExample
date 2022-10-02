import Foundation
import Combine

// MARK: - Protocols
protocol APIRequestable: Encodable {
    associatedtype ResponseType: Decodable
    
    var path: String { get }
    var method: HTTPMethod { get }
}

struct APIResponse<T: Decodable> {
    public let statusCode: Int
    public var object: T?
}

// MARK: - Client
public class APIClient {
    let baseUrl: URL
    let session: URLSession
    
    init(baseUrl: URL, session: URLSession = .shared) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func send<T: Decodable>(request: URLRequest) -> AnyPublisher<APIResponse<T>, APIClientError> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> APIResponse<T> in
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: result.data)
                guard let statusCode = (result.response as? HTTPURLResponse)?.statusCode else {
                    throw APIClientError.network
                }
                return APIResponse(statusCode: statusCode, object: value)
            }
            .mapError { error -> APIClientError in
                if let apiError = error as? APIClientError {
                    return apiError
                } else if error is DecodingError {
                    return .decoding
                } else {
                    return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func send<T: APIRequestable>(
        requestable: T
    ) -> AnyPublisher<APIResponse<T.ResponseType>, APIClientError> {
        let urlRequest = buildUrlRequest(for: requestable)
        return send(request: urlRequest)
    }
    
    func buildUrlRequest<T: APIRequestable>(for requestable: T) -> URLRequest {
        var requestUrl = baseUrl.appendingPathComponent(requestable.path)
        if requestable.method == .GET {
            requestUrl = appendQueryParameters(to: requestUrl, parameters: requestable)
        }
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = requestable.method.description
        if requestable.method != .GET {
            urlRequest = encodeBodyJSON(parameters: requestable, request: urlRequest)
        }
        return urlRequest
    }
    
    private func appendQueryParameters(to url: URL, parameters: Encodable?) -> URL {
        if let params = parameters, let urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) {
            var mutableUrlComponents = urlComponents
            if let paramDict = params.dictionaryData() {
                let queryItems = paramDict.map { (key: String, value: Any) -> URLQueryItem in
                    return URLQueryItem(name: key, value: "\(value)")
                }
                var allItems = mutableUrlComponents.queryItems ?? [URLQueryItem]()
                allItems.append(contentsOf: queryItems)
                mutableUrlComponents.queryItems = allItems
            }
            if let url = mutableUrlComponents.url {
                return url
            }
        }
        return url
    }
    
    private func encodeBodyJSON(parameters: Encodable?, request: URLRequest) -> URLRequest {
        var encodedRequest = request
        encodedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let params = parameters {
            do {
                let data = try params.jsonData()
                encodedRequest.httpBody = data
            } catch {
                print("Error encoding JSON body:\n\(error)")
            }
        }
        return encodedRequest
    }
}

// MARK: - Enums
enum HTTPMethod: CustomStringConvertible {
    case GET
    case PUT
    case POST
    
    public var description: String {
        switch self {
        case .GET:
            return "GET"
        case .PUT:
            return "PUT"
        case .POST:
            return "POST"
        }
    }
}

enum APIClientError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "Unknown network error occurred"
        case .decoding:
            return "Decoding error occurred"
        }
    }
}

// MARK: - Extensions
fileprivate extension Encodable {
    func jsonData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
    
    func dictionaryData() -> [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        )).flatMap { $0 as? [String: Any] }
    }
}
