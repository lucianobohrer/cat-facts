import ReactiveSwift
import Foundation
import ComposableArchitecture

protocol CatFactServiceProtocol {
    func factApi() -> Effect<String, ApiError>
}

final class CatFactService: CatFactServiceProtocol {
    enum CatFactServiceError: Error {
        case badUrl
    }

    func factApi() -> SignalProducer<String, ApiError> {
        guard let url = URL(string: "https://catfact.ninja/fact") else {
            return .empty
        }
        return URLSession.shared.reactive
            .data(with: URLRequest(url: url))
            .map { data, response -> String in
                guard
                    let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                else {
                    return ""
                }
                return (dictionary["fact"] as? String) ?? ""
            }.flatMapError { _ in
                SignalProducer<String, ApiError>(value: "Problem fetching the fact")
            }
    }
}
