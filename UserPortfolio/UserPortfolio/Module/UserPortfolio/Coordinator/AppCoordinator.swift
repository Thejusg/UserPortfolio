//
//  AppCoordinator.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start(animated: Bool)
}

final class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let portfolioVC = UserPortfolioViewController(viewModel: UserPortfolioViewModel())
        portfolioVC.coordinator = self
        navigationController.pushViewController(portfolioVC, animated: animated)
    }
}
