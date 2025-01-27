//
//  UserPortfolioViewModelTest.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 26/01/25.
//

import Foundation
import Combine
import XCTest
@testable import UserPortfolio

final class UserPortfolioViewModelTests: XCTestCase {
    private var viewModel: UserPortfolioViewModel!
    private var mockRepository: MockUserPortfolioRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserPortfolioRepository()
        viewModel = UserPortfolioViewModel(userPortfolioRepository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchUserHoldings_Success() {
        guard let data = loadMockDataFromJSON(), let mockPortfolioResponse = decodeCachedData(data: data) else {
            XCTFail("Failed to load or decode mock data")
            return
        }
        
        mockRepository.fetchHoldingsResult = mockPortfolioResponse
        
        let expectation = XCTestExpectation(description: "Fetch user holdings successfully")
        var response: [UserHolding]?
        var errorMessage: String?
        
        viewModel.reloadDataPublisher
            .sink {
                response = self.viewModel.holdings
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.showErrorPublisher
            .sink {
                errorMessage = self.viewModel.errorMessage
            }
            .store(in: &cancellables)
        
        viewModel.fetchUserHoldings()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.count, mockPortfolioResponse.userHolding.count)
        XCTAssertEqual(response?[0].symbol, mockPortfolioResponse.userHolding[0].symbol)
        XCTAssertNil(errorMessage)
    }
    
    func testFetchUserHoldings_Failure() {
        let mockError = NSError(domain: "TestError", code: 999, userInfo: [NSLocalizedDescriptionKey: "API Request Failed"])
        mockRepository.fetchHoldingsError = mockError
        let expectation = XCTestExpectation(description: "Fetch user holdings failed")
        var fetchedHoldings: [UserHolding]?
        var errorMessage: String?
        viewModel.reloadDataPublisher
            .sink {
                fetchedHoldings = self.viewModel.holdings
            }
            .store(in: &cancellables)
        
        viewModel.showErrorPublisher
            .sink {
                errorMessage = self.viewModel.errorMessage
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchUserHoldings()
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(fetchedHoldings)
        XCTAssertNotNil(errorMessage)
        XCTAssertEqual(errorMessage, "API Request Failed")
    }
    
    func testUserPortfolioComputedProperties() {
        let mockPortfolio = [
            UserHolding(symbol: "MAHABANK", quantity: 990, ltp: 38.05, avgPrice: 35, close: 40),
            UserHolding(symbol: "ICICI", quantity: 100, ltp: 118.25, avgPrice: 110, close: 105)
        ]
        
        mockRepository.fetchHoldingsResult = UserPortfolioServiceResponse(userHolding: mockPortfolio)
        
        let expectation = XCTestExpectation(description: "Fetch user holdings successfully")
        
        var fetchedHoldings: [UserHolding]?
        viewModel.reloadDataPublisher
            .sink {
                fetchedHoldings = self.viewModel.holdings
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchUserHoldings()
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(fetchedHoldings)
        XCTAssertEqual(self.viewModel.currentValue, 49494.5)
        XCTAssertEqual(self.viewModel.totalInvestment, 45650)
        XCTAssertEqual(self.viewModel.todaysPNL, 605.5000000000027)
        XCTAssertEqual(self.viewModel.totalPNL, 3844.5)
        XCTAssertEqual(Utility.formatValue(for: self.viewModel.totalPNL), "₹3,844.5")
    }
    
    func decodeCachedData(data: Data) -> UserPortfolioServiceResponse? {
        do {
            let decoder = JSONDecoder()
            let portfolioResponse = try decoder.decode(UserPortfolioServiceResponse.self, from: data)
            return portfolioResponse
        } catch {
            print("Failed to decode mock data: \(error)")
            return nil
        }
    }
    
    func loadMockDataFromJSON() -> Data? {
        guard let url = Bundle.main.url(forResource: "mockPortfolioResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        
       return data
    }
}
