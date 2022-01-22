//
//  StandardCryptoRemoteRepository.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine
import CryptoAPI
import OSLog

final class StandardCryptoRemoteRepository {
    static let shared = StandardCryptoRemoteRepository()
    
    private lazy var cryptoClient: Crypto = Crypto(delegate: self)
    private var priceUpdateSubject = PassthroughSubject<PriceUpdateData, Never>()
    // Just to mock a real env connection (currently the api is getting
    // disconnected after a time by itself)
    private var shouldBeSubscribed = false
    private var isSubscribed = false
}

extension StandardCryptoRemoteRepository: CryptoRemoteRepository {
    var priceUpdatePublisher: AnyPublisher<PriceUpdateData, Never> {
        priceUpdateSubject.eraseToAnyPublisher()
    }
    
    func loadCryptoCurrencies() -> [CryptoCurrencyData] {
        cryptoClient.getAllCoins().map { CryptoCurrencyData(coin: $0) }
    }
    
    func subscribeToPriceUpdates() -> Result<Bool, Error> {
        shouldBeSubscribed = true
        return cryptoClient.connect()
    }
    
    func unsubscribeFromPriceUpdates() {
        shouldBeSubscribed = false
        cryptoClient.disconnect()
    }
}

extension StandardCryptoRemoteRepository: CryptoDelegate {
    func cryptoAPIDidConnect() {
        isSubscribed = true
    }
    
    func cryptoAPIDidUpdateCoin(_ coin: CryptoAPI.Coin) {
        priceUpdateSubject.send(PriceUpdateData(currencyId: coin.code,
                                                value: coin.price,
                                                date: Date()))
    }

    func cryptoAPIDidDisconnect() {
        isSubscribed = false
        guard shouldBeSubscribed else { return }
        // Client will disconnect after a coupe of seconds, so I'll try to reconnect
        let result = cryptoClient.connect()
        if case let .failure(error) = result {
            os_log("Crypto remote repository failed to reconnect with error: %@", error as CVarArg)
        }
    }
}

private extension CryptoCurrencyData {
    init(coin: CryptoAPI.Coin) {
        self.init(id: coin.code,
                  name: coin.name,
                  imageURL: coin.imageUrl,
                  currentValue: coin.price,
                  previousKnownValue: nil,
                  maxValue: nil,
                  minValue: nil)
    }
}
