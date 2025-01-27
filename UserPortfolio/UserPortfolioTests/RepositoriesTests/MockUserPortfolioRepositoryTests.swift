//
//  MockUserPortfolioRepositoryTests.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 26/01/25.
//

import Foundation
import Combine
import XCTest
@testable import UserPortfolio

final class MockUserPortfolioRepositoryTests: XCTestCase {
    private var apiClient: MockAPIClient!
    private var userDefaultsCache: UserDefaults!
    
    override func setUp() {
        super.setUp()
        userDefaultsCache = UserDefaults(suiteName: "Test")
        apiClient = MockAPIClient()
    }
    
    override func tearDown() {
        userDefaultsCache?.removePersistentDomain(forName: "Test")
        apiClient = nil
        super.tearDown()
    }
    
    func testFetchPortfolioHoldings_APIResponse_Success() {
        guard let mockPortfolioResponse = loadMockDataFromJSON() else {
            XCTFail("Failed to load mock data")
            return
        }
        
        let expectation = XCTestExpectation(description: "Fetch portfolio holdings")
        
        var response: UserPortfolioServiceResponse?
        var error: Error?
        apiClient.mockResponse = mockPortfolioResponse
        
        let repository = UserPortfolioRepository(apiClient: apiClient, userDefaultsCache: userDefaultsCache)
        _ = repository.fetchPortfolioHoldings()
            .sink { completion in
                if case .failure(let fetchError) = completion {
                    error = fetchError
                }
            } receiveValue: { userPortfolio in
                response = userPortfolio
                expectation.fulfill()
            }
        XCTAssertNil(error)
        XCTAssertEqual(response?.userHolding.first?.symbol, "MAHABANK")
        XCTAssertEqual(response?.userHolding.first?.quantity, 990)
        XCTAssertTrue(response?.userHolding.isEmpty == false)
    }
    
    func testFetchPortfolioHoldings_APIResponse_Error_UsesCache() {
        guard let data = loadMockDataFromJSON(), let cachedPortfolioResponse = decodeCachedData(data: data)  else {
            XCTFail("Failed to load mock data")
            return
        }
        userDefaultsCache.set(try? JSONEncoder().encode(cachedPortfolioResponse), forKey: "CachedUserPortfolio")
        apiClient.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Fetch portfolio holdings")
        
        var response: UserPortfolioServiceResponse?
        var error: Error?
        
        let repository = UserPortfolioRepository(apiClient: apiClient, userDefaultsCache: userDefaultsCache)
        _ = repository.fetchPortfolioHoldings()
            .sink(receiveCompletion: { completion in
                if case .failure(let fetchError) = completion {
                    error = fetchError
                }
            }, receiveValue: { portfolio in
                response = portfolio
                expectation.fulfill()
            })
        
        XCTAssertNil(error)
        XCTAssertEqual(response, cachedPortfolioResponse)
    }
    
    func testFetchPortfolioHoldings_NoCache() {
        apiClient.shouldReturnError = true
        userDefaultsCache.set(nil, forKey: "CachedUserPortfolio")
        let expectation = XCTestExpectation(description: "Fail to fetch portfolio holdings and no cache available")
        
        var response: UserPortfolioServiceResponse?
        var error: Error?
        let repository = UserPortfolioRepository(apiClient: apiClient, userDefaultsCache: userDefaultsCache)
        
        _ = repository.fetchPortfolioHoldings()
            .sink(receiveCompletion: { completion in
                if case .failure(let fetchError) = completion {
                    error = fetchError
                }
            }, receiveValue: { portfolio in
                response = portfolio
                expectation.fulfill()
            })
        
        
        XCTAssertNotNil(error)
        XCTAssertNil(response)
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
