//
//  TagLabel.swift
//  CryptoWIP
//
//  Created by Adrian Zghibarta on 22.01.2022.
//

import UIKit
import SnapKit

final class TagLabel: UIView {
    enum Theme {
        case green, red, normal
    }
    
    // MARK: - UI Elements
    
    private let label: UILabel = {
        $0.setTextStyle(.callout, color: .accentText)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = .spacingSmall2
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: .spacingMedium1,
                                                           vertical: .spacingSmall2))
            $0.height.greaterThanOrEqualTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public layer
    
    func setText(_ text: String?, theme: Theme, animated: Bool, delayed: Bool = false) {
        let backgroundColor: UIColor
        
        switch theme {
        case .green:
            backgroundColor = .positiveAlert
        case .red:
            backgroundColor = .negativeAlert
        case .normal:
            backgroundColor = .contrastBackground
        }
        
        guard animated else {
            label.text = text
            self.backgroundColor = backgroundColor
            return
        }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.4,
            options: [.curveEaseIn, .allowUserInteraction],
            animations: { [weak self] in
                guard let self = self else { return }
                self.label.text = text
                self.backgroundColor = backgroundColor
            },
            completion: { [weak self] finished in
                guard let self = self, finished, theme != .normal else { return }
                self.setText(text, theme: .normal, animated: true, delayed: true)
            }
        )
    }
}
