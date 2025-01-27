//
//  UserPortfolioViewController.swift
//  UserPortfolio
//
//  Created by Thejus G on 22/01/25.
//

import UIKit
import Combine

enum HoldingSection {
    case main
}

final class UserPortfolioViewController: UIViewController {
    //MARK: - Value Types
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HoldingSection, UserHolding>
    private typealias DataSource = UICollectionViewDiffableDataSource<HoldingSection, UserHolding>
    
    // MARK: - UIView Configurations
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var summaryView: UserPortfolioSummaryView = {
        let view = UserPortfolioSummaryView()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var dataSource = createDataSource()
    
    private let viewModel: UserPortfolioViewModel
    weak var coordinator: AppCoordinator?
    
    // MARK: - Life Cycle Methods
    init(viewModel: UserPortfolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        setupCollectionView()
        setupPortfolioSummaryView()
        setupErrorView()
        registerCells()
        configurePublisher()
        viewModel.fetchUserHoldings()
    }
    
    private func refreshViews() {
        updateSnapShot()
        summaryView.configureViews(summaryInfo: viewModel.getPortfolioSummaryInfo())
        summaryView.isHidden = false
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserHoldingCell.reuseIdentifier, for: indexPath) as? UserHoldingCell else { return UICollectionViewCell() }
            cell.configure(with: item)
            return cell
        }
        return dataSource
    }
    
    private func updateSnapShot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.holdings)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    func configurePublisher() {
        viewModel.reloadDataPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isOffline(false)
                self.refreshViews()
            }.store(in: &viewModel.cancellables)
        
        viewModel.showErrorPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isOffline(true)
                self.errorView.showError(message: viewModel.errorMessage ?? "") { [weak self] in
                    self?.viewModel.fetchUserHoldings()
                }
            }.store(in: &viewModel.cancellables)
    }
    
    func isOffline(_ state: Bool) {
        self.errorView.isHidden = !state
        self.summaryView.isHidden = state
    }
    
    func styleView() {
        title = Constants.holdings
    }
}

//MARK: - Setup Views
private extension UserPortfolioViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupPortfolioSummaryView() {
        view.addSubview(summaryView)
        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupErrorView() {
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func registerCells() {
        collectionView.register(UserHoldingCell.self, forCellWithReuseIdentifier: UserHoldingCell.reuseIdentifier)
    }
}

//MARK: - Layout Configurations
private extension UserPortfolioViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let itemSize =  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        return layout
    }
}
