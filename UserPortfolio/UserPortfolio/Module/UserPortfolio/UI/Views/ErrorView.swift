//
//  ErrorView.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import UIKit

final class ErrorView: UIStackView {
    
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return button
    }()
        
    var onRetry: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 12
        alignment = .center
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addArrangedSubview(iconView)
        addArrangedSubview(messageLabel)
        addArrangedSubview(retryButton)
        
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
    
    func showError(message: String, onRetry: @escaping () -> Void) {
        self.messageLabel.text = message
        self.onRetry = onRetry
    }
}

