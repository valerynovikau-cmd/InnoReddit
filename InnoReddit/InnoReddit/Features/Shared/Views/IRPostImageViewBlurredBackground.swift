//
//  IRPostImageViewBlurredBackground.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 21.11.25.
//

import UIKit

final class IRPostImageViewBlurredBackground: UIImageView {
    
    private let shadowOpacity: Float = 0.5
    private let shadowRadius: CGFloat = 10
    
    private lazy var childImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.darkGray.cgColor
        imageView.layer.shadowOpacity = shadowOpacity
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = shadowRadius
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
        self.addSubview(childImageView)
        NSLayoutConstraint.activate([
            childImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            childImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            childImageView.topAnchor.constraint(equalTo: self.topAnchor),
            childImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IRPostImageViewBlurredBackground {
    func setBackgorundImage(image: UIImage?, animationInterval: TimeInterval? = nil) {
        self.image = image
        if let animationInterval {
            self.alpha = 0
            UIView.animate(withDuration: animationInterval) {
                self.alpha = 1
            }
        }
    }
    
    func setImage(image: UIImage?, animationInterval: TimeInterval? = nil) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        childImageView.image = image
        if let animationInterval {
            childImageView.alpha = 0
            UIView.animate(withDuration: animationInterval) { [weak self] in
                self?.childImageView.alpha = 1
            }
        }
    }
}
