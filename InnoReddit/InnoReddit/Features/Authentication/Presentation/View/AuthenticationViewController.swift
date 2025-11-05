//
//  AuthenticationViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit
import SwiftUI

class AuthenticationViewController: UIViewController {

    var output: AuthenticationViewPresenterProtocol?
    
    // MARK: UI Elements
    
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
        view.layer.cornerRadius = 25
        view.dynamicBorderColor = Asset.Colors.innoSecondaryBackgroundColor.color
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: (view.frame.width < view.frame.height ? view.frame.width : view.frame.height) - 50),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.width - 25),
        ])
    }
    
    // MARK: - Reddit icon container view
    
    private lazy var redditImageContainerView: UIView = {
        let view = IRDynamicBorderedView()
        view.backgroundColor = Asset.Colors.innoOrangeColor.color
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        view.dynamicBorderColor = Asset.Colors.innoSecondaryBackgroundColor.color
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureRedditImageContainerView() {
        containerView.addSubview(redditImageContainerView)
        NSLayoutConstraint.activate([
            redditImageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            redditImageContainerView.widthAnchor.constraint(equalToConstant: 100),
            redditImageContainerView.heightAnchor.constraint(equalTo: redditImageContainerView.widthAnchor),
            redditImageContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    // MARK: - Reddit image view
    
    private lazy var redditImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Images.redditIcon.image
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureRedditImageView() {
        redditImageContainerView.addSubview(redditImageView)
        NSLayoutConstraint.activate([
            redditImageView.widthAnchor.constraint(equalTo: redditImageContainerView.widthAnchor, multiplier: 0.75),
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
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureWelcomeLabel() {
        containerView.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: redditImageView.bottomAnchor, constant: 10),
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Welcome description label view
    
    private lazy var welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        let text = AuthenticationLocalizableStrings.inforamtionLabelText
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureWelcomeDescriptionLabel() {
        containerView.addSubview(welcomeDescriptionLabel)
        NSLayoutConstraint.activate([
            welcomeDescriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Login button

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let title = AuthenticationLocalizableStrings.logInWithRedditButtonText
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = Asset.Colors.innoOrangeColor.color
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureLoginButton() {
        containerView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: termsOfServiceLabel.topAnchor, constant: -20),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
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
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureTermsOfServiceLabel() {
        containerView.addSubview(termsOfServiceLabel)
        NSLayoutConstraint.activate([
            termsOfServiceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            termsOfServiceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            termsOfServiceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
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
        self.configureTermsOfServiceLabel()
        self.configureLoginButton()
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
        self.loginButton.isEnabled = false
    }
    
    func enableLoginButton() {
        self.loginButton.isEnabled = true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

struct AuthenticationViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            AuthenticationViewController()
        }
        .ignoresSafeArea()
    }
}
