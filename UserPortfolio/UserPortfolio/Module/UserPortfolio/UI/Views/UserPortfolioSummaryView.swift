//
//  UserPortfolioSummaryView.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import UIKit

final class UserPortfolioSummaryView: UIView {
    //MARK: - UIView Configurations
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let expandStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isHidden = true
        return stackView
    }()
    
    private let collapsedStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var chevronButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        let symbol = UIImage(systemName: "chevron.up", withConfiguration: symbolConfig)
        button.setImage(symbol, for: .normal)
        button.tintColor = .label
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(expandOrCollapseView), for: .touchUpInside)
        return button
    }()
    
    private let totalPNLStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()
    
    private var isExpanded: Bool = false
    
    //MARK: - Life Cycle Methods
    init() {
        super.init(frame: .zero)
        styleContainerView()
        setupMainStackView()
        mainStackView.addSubViews(elements: [expandStackView, collapsedStackView])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureViews(summaryInfo: PortfolioSummaryInfo) {
        totalPNLStackView.addSubViews(elements: [getKeyLabel(key: summaryInfo.totalPNL.0), chevronButton])
        collapsedStackView.addSubViews(elements: [totalPNLStackView, UIView(), getValueLabel(value: summaryInfo.totalPNL.1, isPNL: true)])
        
        for (key, value) in summaryInfo.components {
            expandStackView.addSubViews(elements: [getKeyValueStackView(key: key, value: value, isPNL: key == Constants.todaysPNL)])
        }
        expandStackView.addArrangedSubview(separatorView)
    }
    
    @objc private func expandOrCollapseView() {
        isExpanded.toggle()
        expandStackView.alpha = !isExpanded ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.expandStackView.isHidden = !self.isExpanded
            self.expandStackView.alpha = !self.isExpanded ? 0 : 1
        })
        toggleChevron()
    }
}

//MARK: - Setup Views
private extension UserPortfolioSummaryView {
    func setupMainStackView() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant:  -12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func styleContainerView() {
        backgroundColor = .systemGray6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray3.cgColor
    }
}

//MARK: Helper Functions
private extension UserPortfolioSummaryView {
    func getKeyValueStackView(key: String, value: String, isPNL: Bool = false) -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.addSubViews(elements: [getKeyLabel(key: key), UIView(), getValueLabel(value: value, isPNL: isPNL)])
        return stackView
    }
    
    func getKeyLabel(key: String) -> UILabel {
        let keyLabel = UILabel()
        keyLabel.font = .systemFont(ofSize: 16)
        keyLabel.textColor = .label
        keyLabel.text = key
        return keyLabel
    }
    
    func getValueLabel(value: String, isPNL: Bool = false ) -> UILabel {
        let valueLabel = UILabel()
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.textColor = .label
        valueLabel.text = value
        valueLabel.textColor = isPNL ? isNegativeAmount(value) ? .systemRed : .systemGreen : .label
        return valueLabel
    }
    
    func toggleChevron() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.chevronButton.transform = self.chevronButton.transform.rotated(by: .pi)
        }
    }
    
    func isNegativeAmount(_ amountString: String) -> Bool {
        let cleanedString = amountString.replacingOccurrences(of: "[^0-9.-]", with: "", options: .regularExpression)
        return Double(cleanedString).map { $0 < 0 } ?? false
    }
}
