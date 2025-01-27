//
//  Label+Extension.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import UIKit

extension UILabel {
    func configureKeyValue(_ keyName: String, _ value: String, _ valueTextColor: UIColor = .label) {
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: valueTextColor
        ]
        let keyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .caption2),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let key = NSMutableAttributedString(string: "\(keyName): ", attributes: keyAttributes)
        let value = NSMutableAttributedString(string: "\(value)", attributes: valueAttributes)
        let result = NSMutableAttributedString(string: "")
        result.append(key)
        result.append(value)
        attributedText = result
    }
}
