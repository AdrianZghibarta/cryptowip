//
//  CryptoListViewModel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine

enum CryptoListViewModelEvent {
    case itemSelected(cryptoCurrencyId: String)
}

protocol CryptoListViewModel {
    var title: String { get }
    var cellsPublisher: AnyPublisher<[CryptoItemViewModel], Never> { get }
    var eventPublisher: AnyPublisher<CryptoListViewModelEvent, Never> { get }
    
    func onViewDidLoad()
    func onSelect(cell: CryptoItemViewModel)
}
