import ReactiveSwift
import Foundation

enum CatFactEndpoint {
    case fact
}

extension CatFactEndpoint: EndpointProtocol {
    var scheme: String {
        "https"
    }

    var host: String {
        "catfact.ninja"
    }

    var path: String {
        switch self {
        case .fact:
            return "/fact"
        }
    }

    var method: RequestMethod {
        switch self {
        case .fact:
            return .get
        }
    }

    var header: [String : String]? {
        nil
    }

    var body: [String : Any]? {
        nil
    }
}

protocol CatFactProtocol {
    var fact: String? { get set }
}

struct CatFactModel: CatFactProtocol, Decodable, Equatable {
    var fact: String?
}

protocol CatFactServiceProtocol {
    func factApi() -> SignalProducer<CatFactModel, KonohaError>
}

struct CatFactService: CatFactServiceProtocol, Konoha{
    func factApi() -> SignalProducer<CatFactModel, KonohaError> {
        return request(endpoint: CatFactEndpoint.fact,
                       responseType: CatFactModel.self)
    }
}
