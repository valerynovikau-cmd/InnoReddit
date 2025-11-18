//
//  AuthenticationPresenterProtocol.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 31.10.25.
//

protocol AuthenticationViewPresenterProtocol: AnyObject {
    var input: AuthenticationViewProtocol? { get set }
    func didTapAuthenticateWithReddit()
    func goToMainFlowIfAuthenticated()
}
