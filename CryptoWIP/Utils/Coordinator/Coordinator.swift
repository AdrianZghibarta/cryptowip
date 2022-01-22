//
//  Coordinator.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 20.01.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    /// Parent coordinator that usually pushes / presents / manages current coordinator.
    /// Needs to be set before starting current coordinator.
    var parentCoordinator: Coordinator? { get set }
    
    /// The list of all child coordinators that current coordinator manages
    var childCoordinators: [Coordinator] { get set }
    
    /// Main view controller instance
    var viewController: UIViewController? { get }
    
    /// Navigation view controller if current coordinator supports it
    var navigationController: UINavigationController? { get }
    
    /// Start the coordinator, this usually means presenting / showing the needed view / navigation controller
    func start(animated: Bool)
    
    /// End the coordinator
    func end(animated: Bool)
    
    /// Called by the child coordinator when it started showing
    func didStart(child: Coordinator)
    
    /// Called by the child coordinator when it ended his activity
    func didEnd(child: Coordinator, with result: CoordinatorResult?)
}

protocol CoordinatorResult { /* No op */ }

extension Coordinator {
    func end(animated: Bool) {
        parentCoordinator?.didStart(child: self)
    }
    
    func didStart(child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func didEnd(child: Coordinator, with result: CoordinatorResult?) {
        childCoordinators.removeAll { $0 === child }
    }
    
    func parentPresenter() -> UIViewController? {
        parentCoordinator?.navigationController ?? parentCoordinator?.viewController
    }
}
