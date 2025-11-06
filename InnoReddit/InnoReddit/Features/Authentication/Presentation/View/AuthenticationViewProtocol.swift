//
//  AuthenticationViewProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

protocol AuthenticationViewProtocol: AnyObject {
    var output: AuthenticationViewPresenterProtocol? { get set }
    func showAlert(title: String, message: String)
    func disableLoginButton()
    func enableLoginButton()
}
