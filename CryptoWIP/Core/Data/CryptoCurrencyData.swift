//
//  CryptoCurrencyData.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 20.01.2022.
//

import Foundation

struct PriceUpdateData {
    var currencyId: String
    var value: Double
    var date: Date
}

struct CryptoCurrencyData {
    var id: String
    var name: String
    var imageURL: String?
    var currentValue: Double
    var previousKnownValue: Double?
    var maxValue: Double?
    var minValue: Double?
}
