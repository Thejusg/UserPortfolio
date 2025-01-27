//
//  UserPortfolioEndpointProvider.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import Foundation

enum UserPortfolioEndpointProvider: EndpointProvider {
    case fetchPortfolio
    
    var baseURL: URL? {
        return URL(string: NetworkConstants.baseUrl)
    }
    
    var path: String {
        switch self {
        case .fetchPortfolio:
            return "35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
        }
    }
}
