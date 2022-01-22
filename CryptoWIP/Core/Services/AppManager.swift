//
//  AppManager.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine
import OSLog

/// Responsible for general app flow management
final class AppManager {
    static let shared = AppManager()
    
    private let cryptoLocalStorage: CryptoLocalStorage
    private let cryptoRepository: CryptoRemoteRepository
    private var subscriptions = Set<AnyCancellable>()
    
    init(cryptoLocalStorage: CryptoLocalStorage = StandardCryptoLocalStorage.shared,
         cryptoRepository: CryptoRemoteRepository = StandardCryptoRemoteRepository.shared,
         mainQueue: DispatchQueue = DispatchQueue.main) {
        self.cryptoLocalStorage = cryptoLocalStorage
        self.cryptoRepository = cryptoRepository
        
        cryptoRepository.priceUpdatePublisher
            .receive(on: mainQueue)
            .sink { [weak self] priceUpdate in
                guard let self = self else { return }
                let result = self.cryptoLocalStorage.savePriceUpdate(priceUpdate)
                if case let .failure(error) = result {
                    os_log("Failed to save price updates with error: %@", error as CVarArg)
                }
            }
            .store(in: &subscriptions)
    }
    
    func onAppWillEnterForeground() {
        let result = cryptoRepository.subscribeToPriceUpdates()
        if case let .failure(error) = result {
            os_log("Failed to subscribe for price updates with error: %@", error as CVarArg)
        }
    }
    
    func onAppDidEnterBackground() {
        cryptoRepository.unsubscribeFromPriceUpdates()
    }
}
