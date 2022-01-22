//
//  PriceHistoryViewController.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine
import CryptoAPI
import UIKit

final class PriceHistoryViewController: UIViewController {
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        $0.setTextStyle(.largeTitle, color: .primaryText)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.adjustsFontForContentSizeCategory = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Other properties
    
    private let viewModel: PriceHistoryViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: PriceHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.isHidden = true
        presentationController?.delegate = self
    }
}

// MARK: - Setup

private extension PriceHistoryViewController {
    func setupBindings() {
        viewModel.titlePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)
    }
    
    func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.readableContentGuide.snp.leading)
            $0.trailing.equalTo(view.readableContentGuide.snp.trailing)
        }
    }
}

// MARK: - Some

extension PriceHistoryViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.onDismiss()
    }
}
