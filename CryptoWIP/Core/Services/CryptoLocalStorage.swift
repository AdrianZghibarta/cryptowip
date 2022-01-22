//
//  CryptoLocalStorage.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Foundation

protocol CryptoLocalStorage {
    func getStoredCryptoCurrencies() -> Result<[CryptoCurrencyData], Error>
    func saveCryptoCurrencies(_ list: [CryptoCurrencyData]) -> Result<Void, Error>
    func savePriceUpdate(_ priceUpdate: PriceUpdateData) -> Result<Void, Error>
}
