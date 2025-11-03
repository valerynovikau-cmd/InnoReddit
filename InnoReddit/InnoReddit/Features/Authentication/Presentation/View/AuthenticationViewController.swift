//
//  AuthenticationViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit

class AuthenticationViewController: UIViewController {

    var output: AuthenticationViewPresenterProtocol?
    
    // MARK: - UI Elements
    
    // MARK: Login button

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let title = AuthenticationLocalizableStrings.logInWithRedditButtonText
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 220),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        self.output?.didTapAuthenticateWithReddit()
    }
    
    // MARK: Root view
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: General view UI configuration
    
    private func configureUI() {
        self.configureRootView()
        self.configureLoginButton()
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        self.output?.goToMainFlowIfAuthenticated()
    }
}

extension AuthenticationViewController: AuthenticationViewProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
