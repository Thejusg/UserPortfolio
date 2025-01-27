//
//  EndpointProvider.swift
//  UserPortfolio
//
//  Created by Thejus G on 22/01/25.
//

import Foundation

public protocol EndpointProvider {
    var baseURL: URL? { get }
    var path: String { get }
}

extension EndpointProvider {
    func createRequest() throws -> URLRequest {
        guard let url = baseURL?.appendingPathComponent(path) else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url)
        return request
    }
}
