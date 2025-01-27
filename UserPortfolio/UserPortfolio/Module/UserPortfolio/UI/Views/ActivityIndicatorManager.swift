//
//  ActivityIndicatorManager.swift
//  UserPortfolio
//
//  Created by Thejus G on 26/01/25.
//

import UIKit

final class ActivityIndicatorManager {
    
    private static var activityIndicator: UIActivityIndicatorView?
    
    static var currentWindow: UIWindow? = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first
    
    static func show() {
        guard let window = currentWindow else {
            print("Error: No key window found")
            return
        }
        
        if activityIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .gray
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(indicator)
            
            // Center the indicator in the window
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            ])
            
            activityIndicator = indicator
        }
        
        activityIndicator?.startAnimating()
    }
    
    static func hide() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
}
