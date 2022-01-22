//
//  StandardPriceHistoryViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import Combine

final class StandardPriceHistoryViewModel: PriceHistoryViewModel {
    // MARK: - PriceHistoryViewModel properties
    
    lazy var titlePublisher: AnyPublisher<String?, Never> = {
        $title.eraseToAnyPublisher()
    }()
    lazy var eventPublisher: AnyPublisher<PriceHistoryViewModelEvent, Never> = {
        eventSubject.eraseToAnyPublisher()
    }()
    
    @Published private var title: String?
    private let eventSubject = PassthroughSubject<PriceHistoryViewModelEvent, Never>()
    
    init(cryptoCurrencyId: String) {
        title = "Work In Progress .. pun intended 😄"
    }
    
    // MARK: - PriceHistoryViewModel methods
    func onDismiss() {
        eventSubject.send(.viewDismissed)
    }
}
