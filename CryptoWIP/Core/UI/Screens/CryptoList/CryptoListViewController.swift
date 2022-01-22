//
//  CryptoListViewController.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import Combine
import CryptoAPI
import UIKit

final class CryptoListViewController: UIViewController {
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        $0.text = viewModel.title
        $0.setTextStyle(.largeTitle, color: .primaryText)
        $0.adjustsFontForContentSizeCategory = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.estimatedRowHeight = 60
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .background
        $0.separatorStyle = .none
        $0.contentInset = UIEdgeInsets(horizontal: .noSpacing,
                                       vertical: .spacingMedium2)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    // MARK: - Other properties
    
    private let viewModel: CryptoListViewModel
    private var cellViewModels = [CryptoItemViewModel]()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.isHidden = true
        self.viewModel.onViewDidLoad()
    }
}

// MARK: - Setup

private extension CryptoListViewController {
    func setupBindings() {
        viewModel.cellsPublisher
            .sink { [weak self] in self?.reloadData(cells: $0) }
            .store(in: &subscriptions)
    }
    
    func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacingLarge1)
            $0.leading.equalTo(view.readableContentGuide.snp.leading)
            $0.trailing.equalTo(view.readableContentGuide.snp.trailing)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(view.readableContentGuide.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.trailing.equalTo(view.readableContentGuide.snp.trailing)
        }
        
        tableView.register(cellType: CellView<CryptoItemView>.self)
    }
    
    func reloadData(cells: [CryptoItemViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.cellViewModels = cells
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source and delegate

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        guard cellViewModels.indices.contains(index) else {
            assertionFailure("Currency list failure, out of bounds")
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: CellView<CryptoItemView>.self)
        let viewModel = cellViewModels[index]
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        guard cellViewModels.indices.contains(index) else {
            assertionFailure("Currency list failure, out of bounds")
            return
        }
        let cellVM = cellViewModels[index]
        viewModel.onSelect(cell: cellVM)
    }
}
