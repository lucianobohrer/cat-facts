import Foundation
import ReactiveSwift

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol EndpointProtocol {
    var scheme: String { get }
        var host: String { get }
        var path: String { get }
        var method: RequestMethod { get }
        var header: [String: String]? { get }
        var body: [String: Any]? { get }
}
enum KonohaError: Swift.Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}

protocol Konoha {
    func request<T: Decodable>(endpoint: EndpointProtocol, responseType: T.Type) -> SignalProducer<T, KonohaError>
}

extension Konoha {
    func request<T: Decodable>(endpoint: EndpointProtocol,
                               responseType: T.Type) -> SignalProducer<T, KonohaError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else {
            return .init(error: .invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return URLSession.shared.reactive
            .data(with: request)
            .mapError { _ in
                return .unknown
            }
            .attemptMap { data, response in
                guard
                    let decoded = try? JSONDecoder().decode(responseType, from: data)
                else {
                    return .failure(.decode)
                }
                return .success(decoded)
            }

    }
}
