import UIKit
import ReactiveSwift
import ReactiveCocoa
import ComposableArchitecture

final class CatFactViewController: UIViewController {
    private lazy var factLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    private lazy var refreshButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(viewStore.state.buttonTitle, for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        return view
    }()

    let viewStore: ViewStore<CatFact.State, CatFact.Action>

    init(store: Store<CatFact.State, CatFact.Action>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinds()
    }

    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(factLabel)
        view.addSubview(refreshButton)

        NSLayoutConstraint.activate([
            factLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            factLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            factLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            refreshButton.topAnchor.constraint(equalTo: factLabel.bottomAnchor, constant: 12),
            refreshButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupBinds() {
        refreshButton.reactive
            .controlEvents(.touchUpInside)
            .producer.startWithValues { _ in
                self.viewStore.send(.getFactButtonClicked)
            }

        factLabel.reactive.text <~ viewStore.produced.fact
    }
}

