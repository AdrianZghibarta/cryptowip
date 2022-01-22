//
//  PrefixableLabel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 21.01.2022.
//

import SnapKit
import UIKit

final class PrefixableLabel: UIView {
    // MARK: - UI Elements
    
    private let prefixLabel: UILabel = {
        $0.setTextStyle(.caption2, color: .secondaryText)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let contentLabel: UILabel = {
        $0.setTextStyle(.footnote, color: .primaryText)
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var contentStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .lastBaseline
        $0.spacing = .spacingSmall2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [
        prefixLabel,
        contentLabel
    ]))
    
    // MARK: - Public layer
    
    public var prefixText: String? {
        get { prefixLabel.text }
        set { prefixLabel.text = newValue }
    }
    
    public var contentText: String? {
        get { contentLabel.text }
        set { contentLabel.text = newValue }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
