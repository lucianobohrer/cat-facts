import UIKit
import ReactiveSwift
import ReactiveCocoa

final class CatFactViewWithVMController: UIViewController {
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
        view.setTitle(viewModel.buttonTitle, for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        return view
    }()

    private let viewModel: CatFactViewModelProtocol

    init(viewModel: CatFactViewModelProtocol = CatFactViewModel(services: CatFactService())) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        self.viewModel = CatFactViewModel(services: CatFactService())
        super.init(coder: coder)
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
        let clickEvents = refreshButton.reactive
            .controlEvents(.touchUpInside)
            .producer
            .map({ _ in })

        let outputs = viewModel.bind(refreshAction: clickEvents)

        factLabel.reactive.text <~ outputs.facts
    }
}

