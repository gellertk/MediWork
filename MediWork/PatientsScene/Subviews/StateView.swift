//
//  StateView.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import UIKit

final class StateView: UIView {
    
    // MARK: - Outlets
    
    private let activityIndicatorView: UIActivityIndicatorView =  {
        let activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private let messageLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSelf()
        self.configureSubviews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    private func configureSelf() {
        self.backgroundColor = .white
    }
    
    private func configureSubviews() {
        self.addSubview(self.activityIndicatorView)
        self.addSubview(self.messageLabel)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - Actions

    func show(with newState: ViewState) {
        switch newState {
        case .activityIndicator:
            self.activityIndicatorView.startAnimating()
            self.messageLabel.isHidden = true
        case .message(let text):
            self.activityIndicatorView.stopAnimating()
            self.messageLabel.text = text
            self.messageLabel.isHidden = false
        }
    }
    
    func hide() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }

}

// MARK: - ViewState

extension StateView {
    
    enum ViewState {
        case activityIndicator
        case message(String)
    }
    
}
