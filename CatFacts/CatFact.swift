import ComposableArchitecture
import ReactiveSwift

enum CatFact {
    struct State: Equatable {
        var fact: String = "To start, press refresh button"
        let buttonTitle: String = "Press To Refresh"
    }

    enum Action: Equatable {
        case getFactButtonClicked
        case factResponse(Result<String, ApiError>)
    }

    struct Environment {
        var mainQueue: DateScheduler
        var catFact: () -> Effect<String, ApiError>
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .getFactButtonClicked:
            return environment.catFact()
                .observe(on: environment.mainQueue)
                .catchToEffect(Action.factResponse)
        case let .factResponse(.success(fact)):
            state.fact = fact
            return .none
        case let .factResponse(.failure(error)):
            print("handle error")
            return .none
        }
    }
}

struct ApiError: Error, Equatable {}




