import ComposableArchitecture
import ReactiveSwift

struct CatFactState: Equatable {
    var fact: String = "To start, press refresh button"
    let buttonTitle: String = "Press To Refresh"
}

enum CatFactAction: Equatable {
    case getFactButtonClicked
    case factResponse(Result<String, ApiError>)
}

struct ApiError: Error, Equatable {}

struct CatFactEnvironment {
    var mainQueue: DateScheduler
    var catFact: () -> Effect<String, ApiError>
}

let catFactReducer = Reducer<CatFactState, CatFactAction, CatFactEnvironment> { state, action, environment in
    switch action {
    case .getFactButtonClicked:
        return environment.catFact()
            .observe(on: environment.mainQueue)
            .catchToEffect(CatFactAction.factResponse)
    case let .factResponse(.success(fact)):
        state.fact = fact
        return .none
    case let .factResponse(.failure(error)):
        print("handle error")
        return .none
    }
}
