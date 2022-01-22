//
//  CellView.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import UIKit

/// A protocol that is to be adopted by the view representing table view content.
protocol CellContentView: UIView {
    associatedtype ViewModel

    func prepareForReuse()
    func configure(viewModel: ViewModel)
}

/// UITableView that can adapt to different views content wise
final class CellView<ContentView: CellContentView>: UITableViewCell {
    let content: ContentView
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        content = ContentView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        content.prepareForReuse()
    }

    func configure(viewModel: ContentView.ViewModel) {
        content.configure(viewModel: viewModel)
    }
}
