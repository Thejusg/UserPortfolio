//
//  UserHoldingTests.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 26/01/25.
//

import XCTest
@testable import UserPortfolio

final class UserHoldingTests: XCTestCase {
    func testCurrentValue() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.currentValue, 141411.25)
    }
    
    func testTotalInvestment() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.totalInvestment, 153591.5)
    }
    
    func testTotalPNL() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.totalPNL, -12180.25)
    }
    
    func testTodaysPNL() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.todaysPNL, -21061.25)
    }
    
    func testNetQtyString() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.netQtyString, "415")
    }
    
    func testLtpString() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.ltpString, "₹340.75")
    }
     
    func testTotalPNLString() {
        let holding = UserHolding(symbol: "AIRTEL", quantity: 415, ltp: 340.75, avgPrice: 370.1, close: 290)
        XCTAssertEqual(holding.totalPNLString, "-₹12,180.25")
    }
}
