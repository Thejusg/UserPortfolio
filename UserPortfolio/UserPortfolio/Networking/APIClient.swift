//
//  APIClient.swift
//  UserPortfolio
//
//  Created by Thejus G on 22/01/25.
//

import Foundation
import Combine

public protocol APIRequesting {
    func perfomRequest<T>(endPoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

public final class APIClient: APIRequesting {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func perfomRequest<T>(endPoint: any EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        do {
            let request = try endPoint.createRequest()
            return urlSession
                .dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
