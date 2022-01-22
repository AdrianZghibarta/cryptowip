//
//  StandardCryptoItemViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine
import Foundation

final class StandardCryptoItemViewModel: CryptoItemViewModel {
    // MARK: - CryptoItemViewModel properties
    
    let id: String
    let name: String
    let imageURL: URL?
    lazy var currentPricePublisher: AnyPublisher<PriceUpdate, Never> = {
        $currentPrice
            .map { [weak self] in
                guard let self = self, let value = $0?.priceString else {
                    return PriceUpdate(value: "--/--", animate: false, marker: .none)
                }
                let newPrice = $0 ?? 0
                let oldPrice = self.lastShownPrice ?? 0
                let marker: PriceUpdate.Marker
                let animate = newPrice != oldPrice
                if newPrice < oldPrice {
                    marker = .decrease
                } else if newPrice > oldPrice {
                    marker = .increase
                } else {
                    marker = .none
                }
                self.lastShownPrice = $0
                return PriceUpdate(value: "\(value)",
                                   animate: animate,
                                   marker: marker)
            }
            .eraseToAnyPublisher()
    }()
    lazy var minPricePublisher: AnyPublisher<String?, Never> = {
        $minPrice
            .map { $0?.priceString ?? "--/--" }
            .eraseToAnyPublisher()
    }()
    lazy var maxPricePublisher: AnyPublisher<String?, Never> = {
        $maxPrice
            .map { $0?.priceString ?? "--/--" }
            .eraseToAnyPublisher()
    }()
    
    // MARK: - Other properties
    
    @Published private var currentPrice: Double?
    @Published private var minPrice: Double?
    @Published private var maxPrice: Double?
    
    private var lastShownPrice: Double?
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(data: CryptoCurrencyData,
         cryptoRemoteRepository: CryptoRemoteRepository) {
        id = data.id
        name = data.name
        
        if let imageURLString = data.imageURL {
            imageURL = URL(string: imageURLString)
        } else {
            imageURL = nil
        }

        currentPrice = data.currentValue
        minPrice = data.minValue
        maxPrice = data.maxValue
        
        lastShownPrice = currentPrice
        
        cryptoRemoteRepository.priceUpdatePublisher
            .filter { [weak self] in $0.currencyId == self?.id }
            .sink { [weak self] in
                guard let self = self else { return }
                self.currentPrice = $0.value
                self.maxPrice = max($0.value, self.maxPrice ?? 0)
                self.minPrice = min($0.value, self.minPrice ?? 0)
            }
            .store(in: &subscriptions)
    }
}
