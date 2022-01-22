//
//  StandardCryptoListViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine
import OSLog

final class StandardCryptoListViewModel: CryptoListViewModel {
    // MARK: - CryptoListViewModel properties
    
    let title = "Crypto Market"
    lazy var cellsPublisher: AnyPublisher<[CryptoItemViewModel], Never> = {
        $cells.eraseToAnyPublisher()
    }()
    lazy var eventPublisher: AnyPublisher<CryptoListViewModelEvent, Never> = {
        eventSubject.eraseToAnyPublisher()
    }()
    
    // MARK: - Other properties
    
    
    @Published private var cells = [CryptoItemViewModel]()
    @Published private var eventSubject = PassthroughSubject<CryptoListViewModelEvent, Never>()
    
    private let cryptoLocalStorage: CryptoLocalStorage
    private let cryptoRemoteRepository: CryptoRemoteRepository
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(cryptoLocalStorage: CryptoLocalStorage,
         cryptoRemoteRepository: CryptoRemoteRepository) {
        self.cryptoLocalStorage = cryptoLocalStorage
        self.cryptoRemoteRepository = cryptoRemoteRepository
    }
    
    // MARK: - CryptoListViewModel methods
    
    func onViewDidLoad() {
        loadCryptoCurrencies()
    }
    
    func onSelect(cell: CryptoItemViewModel) {
        eventSubject.send(.itemSelected(cryptoCurrencyId: cell.id))
    }
}

// MARK: - Utils

private extension StandardCryptoListViewModel {
    func loadCryptoCurrencies() {
        let remoteCurrencies = cryptoRemoteRepository.loadCryptoCurrencies()
        let savedCurrenciesResult = cryptoLocalStorage.getStoredCryptoCurrencies()
        
        guard case let .success(savedCurrencies) = savedCurrenciesResult else {
            handle(currencies: remoteCurrencies)
            return
        }
        
        let historyData = Dictionary(grouping: savedCurrencies) { $0.id }
        
        handle(currencies: remoteCurrencies.map {
            var valueToUpdate = $0
            valueToUpdate.update(with: historyData)
            return valueToUpdate
        })
    }
    
    func handle(currencies: [CryptoCurrencyData]) {
        cells = currencies.map {
            StandardCryptoItemViewModel(data: $0,
                                        cryptoRemoteRepository: cryptoRemoteRepository)
        }
        let result = cryptoLocalStorage.saveCryptoCurrencies(currencies)
        guard case .failure(let error) = result else { return }
        os_log("Failed to save conversations with error: %@", error as CVarArg)
    }
}

// MARK: - CryptoCurrencyData

private extension CryptoCurrencyData {
    mutating func update(with historyData: [String: [CryptoCurrencyData]]) {
        guard let oldData = historyData[id]?.first else { return }
        
        if currentValue != oldData.currentValue {
            previousKnownValue = oldData.currentValue
        } else {
            previousKnownValue = oldData.previousKnownValue
        }
        
        let allKnownSortedValues = [
            currentValue,
            previousKnownValue,
            oldData.minValue,
            oldData.maxValue
        ]
            .compactMap { $0 }
            .sorted()
        
        minValue = allKnownSortedValues.first
        maxValue = allKnownSortedValues.last
    }
}
