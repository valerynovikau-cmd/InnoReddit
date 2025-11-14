//
//  IRActivityIndicatorCollectionViewFooter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 13.11.25.
//

import UIKit

final class IRActivityIndicatorCollectionViewFooter: UICollectionReusableView {
    static let reuseIdentifier = "IRActivityIndicatorCollectionViewFooter"
    
    // MARK: - Activity indicator view
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = Asset.Colors.innoOrangeColor.color
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
