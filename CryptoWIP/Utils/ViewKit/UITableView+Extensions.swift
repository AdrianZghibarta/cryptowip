//
//  UITableView+Extensions.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 19.01.2022.
//

import UIKit

extension UITableView {
    func register<CellType: UITableViewCell>(cellType: CellType.Type) {
        register(cellType.self, forCellReuseIdentifier: String(describing: cellType.self))
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>(for indexPath: IndexPath,
                                                        cellType: CellType.Type = CellType.self) -> CellType {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: cellType.self),
                                                  for: indexPath) as? CellType else {
            fatalError("Failed to dequeue a cell, check that the reuseIdentifier is set properly")
        }
        return cell
    }
}
