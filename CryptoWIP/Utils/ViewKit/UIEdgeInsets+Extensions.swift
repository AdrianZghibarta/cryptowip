//
//  UIEdgeInsets+Extensions.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import UIKit

extension UIEdgeInsets {
    init(all inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    init(horizontal hInset: CGFloat, vertical vInset: CGFloat) {
        self.init(top: vInset, left: hInset, bottom: vInset, right: hInset)
    }
}
