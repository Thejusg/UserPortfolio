//
//  UIStackView+Extension.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import UIKit

extension UIStackView {
    public func addSubViews(elements: [UIView]) {
        elements.forEach { element in
            self.addArrangedSubview(element)
        }
    }
}

extension UIApplication {
    static var keyWindow: UIWindow? {
        return shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow
    }
}
