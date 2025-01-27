//
//  ReusableCell.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String {get}
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
