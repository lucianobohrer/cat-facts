import Foundation
import ReactiveSwift

protocol CatFactViewModelProtocol {
    var buttonTitle: String { get }
    func bind(refreshAction: SignalProducer<(), Never>) -> CatFactOutput
}

struct  CatFactOutput {
    let facts: SignalProducer<String, Never>
}

final class CatFactViewModel: CatFactViewModelProtocol {
    let buttonTitle: String = "Press To Refresh"

    private let services: CatFactServiceProtocol

    init(services: CatFactServiceProtocol) {
        self.services = services
    }

    func bind(refreshAction: SignalProducer<(), Never>) -> CatFactOutput {
        let factsSignals = refreshAction.flatMap(.latest) { _ in
            self.services.factApi()
        }

        let result = Property(initial: "Press refresh to start", then: factsSignals).producer

        return CatFactOutput(facts: result.producer)
    }
}
