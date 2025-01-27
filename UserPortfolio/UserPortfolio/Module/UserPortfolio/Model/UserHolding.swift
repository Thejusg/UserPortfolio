//
//  UserHolding.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import Foundation

struct UserPortfolioServiceResponse: Codable, Equatable {
    let userHolding: [UserHolding]
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    private enum DataKeys: String, CodingKey {
        case userHolding
    }
    
    init(userHolding: [UserHolding]) {
        self.userHolding = userHolding
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let holdingContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        userHolding = try holdingContainer.decode([UserHolding].self, forKey: .userHolding)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var holdingContainer = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        try holdingContainer.encode(userHolding, forKey: .userHolding)
    }
}

struct UserHolding: Codable, Hashable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

extension UserHolding {
    
    var currentValue: Double {
        ltp * Double(quantity)
    }

    var totalInvestment: Double {
        avgPrice * Double(quantity)
    }
        
    var totalPNL: Double {
        currentValue - totalInvestment
    }
    
    var todaysPNL: Double {
        (close - ltp) * Double(quantity)
    }
}

extension UserHolding {
    var netQtyString: String {
        "\(quantity)"
    }
    
    var ltpString: String {
        "\(Utility.formatValue(for: ltp))"
    }
    
    var totalPNLString: String {
        "\(Utility.formatValue(for: totalPNL))"
    }
}
