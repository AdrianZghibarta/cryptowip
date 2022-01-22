//
//  PriceHistoryViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine

enum PriceHistoryViewModelEvent {
    case viewDismissed
}

protocol PriceHistoryViewModel {
    var titlePublisher: AnyPublisher<String?, Never> { get }
    var eventPublisher: AnyPublisher<PriceHistoryViewModelEvent, Never> { get }
    
    func onDismiss()
}
