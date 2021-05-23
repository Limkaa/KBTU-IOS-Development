//
//  HeaderLabel.swift
//  SaveMoney
//
//  Created by Alim on 12.05.2021.
//

import Foundation
import UIKit

class HeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray4
        textColor = .black
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        font = UIFont.boldSystemFont(ofSize: 14)
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height/2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 50, height: height)
    }
}
