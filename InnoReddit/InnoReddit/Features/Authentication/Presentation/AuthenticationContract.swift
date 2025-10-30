//
//  AuthenticationContract.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

// MARK: View
protocol AuthenticationViewInput: AnyObject {
    func showAlert(title: String, message: String)
}

// MARK: Presenter
protocol AuthenticationViewOutput: AnyObject {
    func didTapAuthenticateWithReddit()
}
