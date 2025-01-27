//
//  UserPortfolioViewModel.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import Combine
import Foundation

final class UserPortfolioViewModel {
    
    private let userPortfolioRepository: UserPortfolioRepositoryProtocol
    private(set) var holdings: [UserHolding] = []
    
    let reloadDataPublisher: PassthroughSubject<Void, Never> = .init()
    let showErrorPublisher: PassthroughSubject<Void, Never> = .init()
                                
    var errorMessage: String? = nil
    var cancellables = Set<AnyCancellable>()
    
    init(userPortfolioRepository: UserPortfolioRepositoryProtocol = UserPortfolioRepository()) {
        self.userPortfolioRepository = userPortfolioRepository
    }
    
    func fetchUserHoldings() {
        ActivityIndicatorManager.show()
        userPortfolioRepository
            .fetchPortfolioHoldings()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (completion) in
                ActivityIndicatorManager.hide()
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorPublisher.send()
                case .finished: break
                }
            } receiveValue: { [weak self] (response) in
                self?.holdings = response.userHolding
                self?.errorMessage = nil
                self?.reloadDataPublisher.send()
            }.store(in: &cancellables)
    }
    
    func getPortfolioSummaryInfo() -> PortfolioSummaryInfo {
        var components: [(String, String)] = []
        components.append((Constants.currentValue, Utility.formatValue(for: currentValue)))
        components.append((Constants.totalInvestment, Utility.formatValue(for: totalInvestment)))
        components.append((Constants.todaysPNL, Utility.formatValue(for: todaysPNL)))
        
        return PortfolioSummaryInfo(components: components, totalPNL: (Constants.profitNLoss, Utility.formatValue(for: totalPNL)))
    }
}

extension UserPortfolioViewModel {
    var currentValue: Double {
        holdings.reduce(0) { $0 + $1.currentValue }
    }
    
    var totalInvestment: Double {
        holdings.reduce(0) { $0 + $1.totalInvestment }
    }
    
    var todaysPNL: Double {
        holdings.reduce(0) { $0 + $1.todaysPNL }
    }
    
    var totalPNL: Double {
        currentValue - totalInvestment
    }
}
