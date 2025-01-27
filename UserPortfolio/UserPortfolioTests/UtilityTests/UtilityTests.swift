//
//  UtilityTests.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 26/01/25.
//

import XCTest
@testable import UserPortfolio

class UtilityTests: XCTestCase {
    
    func testCurrencySymbols() {
        let eur = Utility.getCurrencySymbol(for: "EUR")
        let gbp = Utility.getCurrencySymbol(for: "GBP")
        XCTAssertEqual(eur, "€")
        XCTAssertEqual(gbp, "£")
    }
    
    func testFormatValue_Failure() {
        let invalidValue = Double.nan
        let nonNumericValue = "abc"
        let invalidNumber = NSNumber(value: 0)
        let formattedValue = Utility.formatValue(for: invalidValue, currencyCode: "INR")
        let fallbackValue = Utility.formatValue(for: Double(nonNumericValue) ?? 0)
        let formattedNonNumeric = Utility.formatValue(for: invalidNumber.doubleValue, currencyCode: "USD")
        
        XCTAssertEqual(formattedValue, "₹NaN")
        XCTAssertEqual(fallbackValue, "₹0")
        XCTAssertEqual(formattedNonNumeric, "$0")
    }
}
