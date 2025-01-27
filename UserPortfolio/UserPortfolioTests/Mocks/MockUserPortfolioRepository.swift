//
//  MockUserPortfolioRepository.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 27/01/25.
//

import Combine
import XCTest
@testable import UserPortfolio

final class MockUserPortfolioRepository: UserPortfolioRepositoryProtocol {
    var fetchHoldingsResult: UserPortfolioServiceResponse?
    var fetchHoldingsError: Error?
    
    func fetchPortfolioHoldings() -> AnyPublisher<UserPortfolioServiceResponse, Error> {
        if let error = fetchHoldingsError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let result = fetchHoldingsResult {
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
    }
}
