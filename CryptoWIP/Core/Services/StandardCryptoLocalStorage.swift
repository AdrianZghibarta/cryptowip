//
//  StandardCryptoLocalStorage.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import OSLog
import RealmSwift

class DBCoinPriceUpdate: Object {
    @Persisted var coinId: String = ""
    @Persisted var value: Double = 0.0
    @Persisted var date: Date = Date()
}

class DBCoin: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var imageURL: String?
    @Persisted var value: Double = 0
}

enum CryptoLocalStorageError: Error {
    case noConnectionToDB
    case operationFailed
}

final class StandardCryptoLocalStorage {
    static let shared = StandardCryptoLocalStorage()
    
    private var realm: Realm?
    
    private func getRealmInstance() -> Realm? {
        guard realm == nil else { return realm }
        
        do {
            let realm = try Realm()
            self.realm = realm
            return realm
        } catch let error as NSError {
            os_log("Realm failed to initialize with error: %@", error)
            return nil
        }
    }
}

extension StandardCryptoLocalStorage: CryptoLocalStorage {
    func getStoredCryptoCurrencies() -> Result<[CryptoCurrencyData], Error> {
        guard let realm = getRealmInstance() else {
            return .failure(CryptoLocalStorageError.noConnectionToDB)
        }
        let allCoins = realm.objects(DBCoin.self)
        let allPriceUpdates = realm.objects(DBCoinPriceUpdate.self)
        
        let result = allCoins.map { coin -> CryptoCurrencyData in
            let priceUpdates = allPriceUpdates.filter { $0.coinId == coin.id }
            let lastPrice = priceUpdates.last
            let sortedPrices = priceUpdates.sorted(by: { $0.value < $1.value })
            let minPrice = sortedPrices.first
            let maxPrice = sortedPrices.last
            return CryptoCurrencyData(id: coin.id,
                                      name: coin.name,
                                      imageURL: coin.imageURL,
                                      currentValue: coin.value,
                                      previousKnownValue: lastPrice?.value,
                                      maxValue: maxPrice?.value,
                                      minValue: minPrice?.value)
        }
        
        return .success(Array(result))
    }
    
    func saveCryptoCurrencies(_ list: [CryptoCurrencyData]) -> Result<Void, Error> {
        guard let realm = getRealmInstance() else {
            return .failure(CryptoLocalStorageError.noConnectionToDB)
        }
        do {
            try realm.write {
                for data in list {
                    let coin = DBCoin()
                    coin.id = data.id
                    coin.name = data.name
                    coin.imageURL = data.imageURL
                    coin.value = data.currentValue
                    realm.add(coin, update: .modified)
                }
            }
            return .success(())
        } catch {
            return .failure(CryptoLocalStorageError.operationFailed)
        }
    }
    
    func savePriceUpdate(_ priceUpdate: PriceUpdateData) -> Result<Void, Error> {
        guard let realm = getRealmInstance() else {
            return .failure(CryptoLocalStorageError.noConnectionToDB)
        }
        
        do {
            let newPriceUpdate = DBCoinPriceUpdate()
            newPriceUpdate.coinId = priceUpdate.currencyId
            newPriceUpdate.value = priceUpdate.value
            newPriceUpdate.date = priceUpdate.date
            try realm.write {
                realm.add(newPriceUpdate)
            }
            return .success(())
        } catch {
            return .failure(CryptoLocalStorageError.operationFailed)
        }
    }
}
