//
//  CryptoRemoteRepository.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine

protocol CryptoRemoteRepository {
    var priceUpdatePublisher: AnyPublisher<PriceUpdateData, Never> { get }
    
    func loadCryptoCurrencies() -> [CryptoCurrencyData] // It's always success
    func subscribeToPriceUpdates() -> Result<Bool, Error>
    func unsubscribeFromPriceUpdates()
}
