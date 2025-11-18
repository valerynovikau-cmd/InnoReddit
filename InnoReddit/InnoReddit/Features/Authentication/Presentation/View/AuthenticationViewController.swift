//
//  AuthenticationViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit
import SwiftUI

class AuthenticationViewController: IRBaseViewController {
    
    var output: AuthenticationViewPresenterProtocol?
    
    // MARK: UI Elements
    private struct AuthenticationViewControllerValues {
        static let interItemSpacing: CGFloat = 10
        static let containerViewTopBottomInnerPadding: CGFloat = 30
        static let containerViewSidesInnerPadding: CGFloat = 20
        
        static let containerViewPadding: CGFloat = 25
        static let containerViewCornerRadius: CGFloat = 25
        static let containerViewBorderWidth: CGFloat = 2
        
        static let redditImageContainerWidth: CGFloat = 100
        static let redditImageContainerCornerRadius: CGFloat = 50
        static let redditImageContainerBorderWidth: CGFloat = 2
        static let redditImageSizeMultiplierToContainer: CGFloat = 0.75
        
        static let primaryLabelFontSize: CGFloat = 30
        static let secondaryLabelFontSize: CGFloat = 14
        
        static let loginButtonLabelFontSize: CGFloat = 18
        static let loginButtonCornerRadius: CGFloat = 10
        static let loginButtonHeight: CGFloat = 50
        static let loginButtonDisablingAnimationDuration: TimeInterval = 0.1
    }
    
    private typealias constants = AuthenticationViewControllerValues
    
    // MARK: - Gradient
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let startColor = Asset.Colors.innoOrangeColor.color.cgColor
        let endColor = Asset.Colors.innoRedColor.color.cgColor
        gradient.colors = [startColor, endColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 1.5, y: 1)
        return gradient
    }()
    
    // MARK: - Root view
    
    private func configureRootView() {
        view.layer.insertSublayer(self.gradient, at: 0)
    }
    
    // MARK: - Container view
    
    private lazy var containerView: UIView = {
        let view = IRDynamicBorderedView()
        view.backgroundColor = Asset.Colors.innoBackgroundColor.color
        view.layer.cornerRadius = constants.containerViewCornerRadius
        view.dynamicBorderColor = Asset.Colors.innoSecondaryBackgroundColor.color
        view.layer.borderWidth = constants.containerViewBorderWidth
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constants.containerViewPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constants.containerViewPadding)
        ])
    }
    
    // MARK: - Reddit image container view
    
    private lazy var redditImageContainerView: UIView = {
        let view = IRDynamicBorderedView()
        view.backgroundColor = Asset.Colors.innoOrangeColor.color
        view.layer.cornerRadius = constants.redditImageContainerCornerRadius
        view.clipsToBounds = true
        view.dynamicBorderColor = Asset.Colors.innoSecondaryBackgroundColor.color
        view.layer.borderWidth = constants.redditImageContainerBorderWidth
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureRedditImageContainerView() {
        containerView.addSubview(redditImageContainerView)
        NSLayoutConstraint.activate([
            redditImageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: constants.containerViewTopBottomInnerPadding),
            redditImageContainerView.widthAnchor.constraint(equalToConstant: constants.redditImageContainerWidth),
            redditImageContainerView.heightAnchor.constraint(equalTo: redditImageContainerView.widthAnchor),
            redditImageContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    // MARK: - Reddit image view
    
    private lazy var redditImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Images.redditIcon.image
        view.layer.cornerRadius = constants.redditImageContainerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureRedditImageView() {
        redditImageContainerView.addSubview(redditImageView)
        NSLayoutConstraint.activate([
            redditImageView.widthAnchor.constraint(equalTo: redditImageContainerView.widthAnchor, multiplier: constants.redditImageSizeMultiplierToContainer),
            redditImageView.heightAnchor.constraint(equalTo: redditImageView.widthAnchor),
            redditImageView.centerXAnchor.constraint(equalTo: redditImageContainerView.centerXAnchor),
            redditImageView.centerYAnchor.constraint(equalTo: redditImageContainerView.centerYAnchor),
        ])
    }
    
    // MARK: - Welcome label view
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        let text = AuthenticationLocalizableStrings.welcomeToInnoRedditLabelText
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: constants.primaryLabelFontSize, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureWelcomeLabel() {
        containerView.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: redditImageContainerView.bottomAnchor, constant: constants.interItemSpacing),
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constants.containerViewSidesInnerPadding),
            welcomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constants.containerViewSidesInnerPadding),
        ])
    }
    
    // MARK: - Welcome description label view
    
    private lazy var welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        let text = AuthenticationLocalizableStrings.inforamtionLabelText
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: constants.secondaryLabelFontSize)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureWelcomeDescriptionLabel() {
        containerView.addSubview(welcomeDescriptionLabel)
        NSLayoutConstraint.activate([
            welcomeDescriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: constants.interItemSpacing),
            welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constants.containerViewSidesInnerPadding),
            welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constants.containerViewSidesInnerPadding),
        ])
    }
    
    // MARK: - Login button

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let title = AuthenticationLocalizableStrings.logInWithRedditButtonText
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: constants.loginButtonLabelFontSize, weight: .bold)
        button.backgroundColor = Asset.Colors.innoOrangeColor.color
        button.tintColor = .white
        button.layer.cornerRadius = constants.loginButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureLoginButton() {
        containerView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: welcomeDescriptionLabel.bottomAnchor, constant: constants.containerViewTopBottomInnerPadding),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constants.containerViewSidesInnerPadding),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constants.containerViewSidesInnerPadding),
            loginButton.heightAnchor.constraint(equalToConstant: constants.loginButtonHeight)
        ])
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        self.output?.didTapAuthenticateWithReddit()
    }
    
    // MARK: - Terms of service label view
    
    private lazy var termsOfServiceLabel: UILabel = {
        let label = UILabel()
        let text = AuthenticationLocalizableStrings.termsOfServiceInfoLabelText
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: constants.secondaryLabelFontSize)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureTermsOfServiceLabel() {
        containerView.addSubview(termsOfServiceLabel)
        NSLayoutConstraint.activate([
            termsOfServiceLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: constants.interItemSpacing),
            termsOfServiceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -constants.containerViewTopBottomInnerPadding),
            termsOfServiceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constants.containerViewSidesInnerPadding),
            termsOfServiceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constants.containerViewSidesInnerPadding),
        ])
    }
    
    // MARK: General view UI configuration
    
    private func configureUI() {
        self.configureRootView()
        self.configureContainerView()
        self.configureRedditImageContainerView()
        self.configureRedditImageView()
        self.configureWelcomeLabel()
        self.configureWelcomeDescriptionLabel()
        self.configureLoginButton()
        self.configureTermsOfServiceLabel()
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        self.output?.goToMainFlowIfAuthenticated()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradient.frame = self.view.bounds
    }
}

extension AuthenticationViewController: AuthenticationViewProtocol {
    func disableLoginButton() {
        UIView.animate(withDuration: constants.loginButtonDisablingAnimationDuration) {
            self.loginButton.isEnabled = false
            self.loginButton.alpha = 0.75
        }
    }
    
    func enableLoginButton() {
        UIView.animate(withDuration: constants.loginButtonDisablingAnimationDuration) {
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1
        }
    }
    
    func showAlert(title: String, message: String) {
        self.presentAlertController(title: title, message: message, buttonTitle: "OK")
    }
}

#Preview {
    ViewControllerPreview {
        let view = AuthenticationViewController()
        return view
    }
    .ignoresSafeArea()
}
