//
//  UserHoldingCell.swift
//  UserPortfolio
//
//  Created by Thejus G on 25/01/25.
//

import UIKit

final class UserHoldingCell: UICollectionViewCell, ReusableCell {
    
    private let holdingName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameAndLTPStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        return stackView
    }()
    
    private let netQtyAndPLStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        return stackView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        return view
    }()
    
    private let netQtyLabel = UILabel()
    private let ltpLabel = UILabel()
    private let profiltLossLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        setupMainStackView()
        setupSeparator()
        nameAndLTPStackView.addSubViews(elements: [holdingName, UIView(), ltpLabel])
        netQtyAndPLStackView.addSubViews(elements: [netQtyLabel, UIView(), profiltLossLabel])
    }
    
    private func setupMainStackView() {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
        mainStackView.addSubViews(elements: [nameAndLTPStackView, netQtyAndPLStackView])
    }
    
    private func setupSeparator() {
        contentView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with holding: UserHolding) {
        holdingName.text = holding.symbol
        netQtyLabel.configureKeyValue(Constants.netQty, holding.netQtyString)
        ltpLabel.configureKeyValue(Constants.ltp, holding.ltpString)
        profiltLossLabel.configureKeyValue(Constants.profitAndLoss, holding.totalPNLString, holding.totalPNL < 0 ? .systemRed : .systemGreen)
    }
}
