//
//  CryptoItemViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine
import Foundation

struct PriceUpdate {
    enum Marker {
        case increase, decrease, none
    }
    
    /// The updated value
    let value: String?
    /// Indicates if the update should be animated
    let animate: Bool
    /// Indicates if the update should be marked as an increase or decrease
    let marker: Marker
}

protocol CryptoItemViewModel {
    var id: String { get }
    var name: String { get }
    var imageURL: URL? { get }
    var currentPricePublisher: AnyPublisher<PriceUpdate, Never> { get }
    var minPricePublisher: AnyPublisher<String?, Never> { get }
    var maxPricePublisher: AnyPublisher<String?, Never> { get }
}
