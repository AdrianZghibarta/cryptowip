//
//  Double+Extensions.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Foundation

extension Double {
    var priceString: String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = self < 1 ? 6 : 2
        
        guard let string = formatter.string(from: self as NSNumber) else {
            return nil
        }
        
        return string
    }
}
