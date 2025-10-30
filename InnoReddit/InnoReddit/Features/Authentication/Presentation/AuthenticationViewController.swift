//
//  AuthenticationViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

import UIKit

class AuthenticationViewController: UIViewController {

    var output: AuthenticationViewOutput?
    
    // MARK: - UI Elements
    
    // MARK: Login button

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти через Reddit", for: .normal)
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
    
    // MARK: General view UI configuration
    
    private func configureUI() {
        self.configureLoginButton()
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

extension AuthenticationViewController: AuthenticationViewInput { }
