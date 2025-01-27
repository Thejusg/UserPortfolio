//
//  MockAPIClient.swift
//  UserPortfolioTests
//
//  Created by Thejus G on 26/01/25.
//

import Combine
import XCTest
@testable import UserPortfolio

final class MockAPIClient: APIRequesting {
    var shouldReturnError = false
    var mockResponse: Data?
    var mockError: Error?
    
    func perfomRequest<T>(endPoint: any EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        if shouldReturnError { return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
            .eraseToAnyPublisher() }
        if let mockError {  return Fail(error: mockError).eraseToAnyPublisher() }
        if let mockResponse {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: mockResponse)
                return Just(decodedResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
