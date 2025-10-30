//
//  AuthenticationContract.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

// MARK: View
protocol AuthenticationViewInput: AnyObject { }

// MARK: Presenter
protocol AuthenticationViewOutput: AnyObject {
    func didTapAuthenticateWithReddit()
}
