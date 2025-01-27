//
//  UserPortfolioRepository.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import Foundation
import Combine

protocol UserPortfolioRepositoryProtocol {
    func fetchPortfolioHoldings() -> AnyPublisher<UserPortfolioServiceResponse, Error>
}

final class UserPortfolioRepository: UserPortfolioRepositoryProtocol {
    private let apiClient: APIRequesting
    private let userDefaultsCache: UserDefaults
    private let cacheKey = "CachedUserPortfolio"
    
    init(apiClient: APIRequesting = APIClient(), userDefaultsCache: UserDefaults = .standard) {
        self.apiClient = apiClient
        self.userDefaultsCache = userDefaultsCache
    }
    
    func fetchPortfolioHoldings() -> AnyPublisher<UserPortfolioServiceResponse, Error> {
        let endPoint = UserPortfolioEndpointProvider.fetchPortfolio
        return apiClient
            .perfomRequest(endPoint: endPoint, responseModel: UserPortfolioServiceResponse.self)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.cachePortfolio(response)
            })
            .catch { [weak self] error -> AnyPublisher<UserPortfolioServiceResponse, Error> in
                guard let self, let cachedData = self.fetchCachedPortfolio() else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return Just(cachedData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

private extension UserPortfolioRepository {
    /// Fetch cached portfolio from UserDefaults
    func fetchCachedPortfolio() -> UserPortfolioServiceResponse? {
        guard let data = userDefaultsCache.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode(UserPortfolioServiceResponse.self, from: data)
    }

    /// Cache the portfolio in UserDefaults
    func cachePortfolio(_ portfolio: UserPortfolioServiceResponse) {
        if let data = try? JSONEncoder().encode(portfolio) {
            userDefaultsCache.set(data, forKey: cacheKey)
        }
    }
}
