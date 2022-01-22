//
//  PriceHistoryCoordinator.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine
import UIKit

final class PriceHistoryCoordinator: Coordinator {
    // MARK: - Coordinator properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    // MARK: - Other properties
    
    private let viewModel: PriceHistoryViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(cryptoCurrencyId: String) {
        viewModel = StandardPriceHistoryViewModel(cryptoCurrencyId: cryptoCurrencyId)
        
        viewModel.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch $0 {
                case .viewDismissed:
                    self?.end(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Coordinator methods
    
    func start(animated: Bool) {
        let viewController = PriceHistoryViewController(viewModel: viewModel)
        parentPresenter()?.present(viewController, animated: animated)
        parentCoordinator?.didStart(child: self)
        
        self.viewController = viewController
    }
    
    func end(animated: Bool) {
        viewController?.dismiss(animated: animated)
        parentCoordinator?.didEnd(child: self, with: nil)
    }
}
