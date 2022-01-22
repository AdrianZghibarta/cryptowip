//
//  CryptoListCoordinator.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 20.01.2022.
//

import Combine
import UIKit

final class CryptoListCoordinator: Coordinator {
    // MARK: - Coordinator properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var viewController: UIViewController? { navigationController?.visibleViewController }
    weak var navigationController: UINavigationController?
    
    // MARK: - Other properties
    
    private let window: UIWindow
    private let viewModel: CryptoListViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(window: UIWindow,
         cryptoLocalStorage: CryptoLocalStorage = StandardCryptoLocalStorage.shared,
         cryptoRemoteRepository: CryptoRemoteRepository = StandardCryptoRemoteRepository.shared) {
        self.window = window
        viewModel = StandardCryptoListViewModel(cryptoLocalStorage: cryptoLocalStorage,
                                                cryptoRemoteRepository: cryptoRemoteRepository)
        viewModel.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .itemSelected(let cryptoCurrencyId):
                    self?.showPriceHistory(cryptoCurrencyId: cryptoCurrencyId)
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Coordinator methods
    
    func start(animated: Bool) {
        let viewController = CryptoListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        if animated {
            UIView.transition(with: window,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
        
        self.navigationController = navigationController
    }
}

// MARK: - Utils

private extension CryptoListCoordinator {
    func showPriceHistory(cryptoCurrencyId: String) {
        let coordinator = PriceHistoryCoordinator(cryptoCurrencyId: cryptoCurrencyId)
        coordinator.parentCoordinator = self
        coordinator.start(animated: true)
    }
}
