//
//  UILabel+Extensions.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 20.01.2022.
//

import UIKit

extension UILabel {
    /// Sets dynamic font based on text style
    /// - Parameters:
    ///   - textStyle: UIFont.TextStyle
    ///   - color: UIColor as textColor
    func setTextStyle(_ textStyle: UIFont.TextStyle, color: UIColor) {
        font = .preferredFont(forTextStyle: textStyle)
        textColor = color
        adjustsFontForContentSizeCategory = true
    }
}
