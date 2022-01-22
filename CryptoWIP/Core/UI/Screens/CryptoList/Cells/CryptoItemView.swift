//
//  CryptoItemView.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine
import SnapKit
import UIKit

private enum Constants {
    static let logoSize: CGFloat = 30
    static let hSpacing: CGFloat = .noSpacing
}

final class CryptoItemView: UIView {
    // MARK: - UI Elements
    
    private let logoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = Constants.logoSize / 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.setTextStyle(.body, color: .primaryText)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let idLabel: UILabel = {
        $0.setTextStyle(.headline, color: .secondaryText)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var mainInfoStackInfo: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = .spacingMedium1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [
        logoImageView,
        nameLabel,
        idLabel
    ]))
    
    private let currentPriceLabel: TagLabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(TagLabel())
    
    private let minPriceLabel: PrefixableLabel = {
        $0.prefixText = "min:"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(PrefixableLabel())
    
    private let maxPriceLabel: PrefixableLabel = {
        $0.prefixText = "max:"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(PrefixableLabel())
    
    private let separatorView: UIView = {
        $0.backgroundColor = .separator
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    // MARK: - Other subscriptions
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Utils

private extension CryptoItemView {
    func setupUI() {
        backgroundColor = .background
        
        addSubview(mainInfoStackInfo)
        addSubview(currentPriceLabel)
        addSubview(minPriceLabel)
        addSubview(maxPriceLabel)
        addSubview(separatorView)
        
        mainInfoStackInfo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.spacingMedium1)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
        }
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: Constants.logoSize, height: Constants.logoSize))
        }
        
        currentPriceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.spacingMedium1)
            $0.leading.greaterThanOrEqualTo(mainInfoStackInfo.snp.trailing).offset(CGFloat.spacingLarge1)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
        }
        
        minPriceLabel.snp.makeConstraints {
            $0.top.equalTo(currentPriceLabel.snp.bottom).offset(CGFloat.spacingMedium2)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.width.greaterThanOrEqualTo(110)
        }
        
        maxPriceLabel.snp.makeConstraints {
            $0.top.equalTo(minPriceLabel.snp.top)
            $0.leading.equalTo(minPriceLabel.snp.trailing).offset(CGFloat.spacingMedium1)
            $0.trailing.lessThanOrEqualTo(readableContentGuide.snp.trailing)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(minPriceLabel.snp.bottom).offset(CGFloat.spacingMedium2)
            $0.leading.equalToSuperview().offset(Constants.hSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.hSpacing)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-CGFloat.spacingMedium1)
        }
    }
    
    func updateCurrentPrice(_ priceUpdate: PriceUpdate) {
        currentPriceLabel.setText(priceUpdate.value,
                                  theme: priceUpdate.marker.tagLabelTheme,
                                  animated: priceUpdate.animate)
    }
}

// MARK: - CellContentView

extension CryptoItemView: CellContentView {
    func configure(viewModel: CryptoItemViewModel) {
        if let imageUrl = viewModel.imageURL {
            logoImageView.load(url: imageUrl)
        }
        
        nameLabel.text = viewModel.name
        idLabel.text = viewModel.id
        
        viewModel.currentPricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] priceUpdate in
                self?.updateCurrentPrice(priceUpdate)
            }
            .store(in: &subscriptions)
        
        viewModel.minPricePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.contentText, on: minPriceLabel)
            .store(in: &subscriptions)
        
        viewModel.maxPricePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.contentText, on: maxPriceLabel)
            .store(in: &subscriptions)
    }
    
    func prepareForReuse() {
        subscriptions = []
        nameLabel.text = nil
        idLabel.text = nil
        currentPriceLabel.setText(nil, theme: .normal, animated: false)
        minPriceLabel.contentText = nil
        maxPriceLabel.contentText = nil
    }
}

// MARK: - Some

private extension PriceUpdate.Marker {
    var tagLabelTheme: TagLabel.Theme {
        switch self {
        case .increase:
            return .green
        case .decrease:
            return .red
        case .none:
            return .normal
        }
    }
}
