//
//  Utility.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import Foundation

class Utility {
    static func getCurrencySymbol(for currencyCode: String, localeIdentifier: String = Locale.current.identifier) -> String {
        var components = Locale.Components(identifier: localeIdentifier)
        components.currency = Locale.Currency(currencyCode)
        let locale = Locale(components: components)
        return locale.currencySymbol ?? "₹"
    }
    
    static func formatValue(for value: Double, currencyCode: String = "INR") -> String {
        let isNegative = value < 0
        let absValue = abs(value)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        let formattedValue = formatter.string(from: NSNumber(value: absValue)) ?? ""
        let currencySymbol = getCurrencySymbol(for: currencyCode)
        return (isNegative ? "-" : "") + currencySymbol + formattedValue
    }
}
