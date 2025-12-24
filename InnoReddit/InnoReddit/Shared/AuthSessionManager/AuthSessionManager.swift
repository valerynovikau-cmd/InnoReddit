//
//  AuthSessionManager.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 24.12.25.
//

import Combine
import Foundation

protocol AuthSessionManagerProtocol: AnyObject {
    var user: UserModel? { get }
    func updateUser(user: UserModel)
    func invalidateUser()
}

final class AuthSessionManager: ObservableObject, AuthSessionManagerProtocol {
    @Published private(set) var user: UserModel?
    private let currentSessionUserModelKey = "CurrentSessionUserModel"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        if let savedUser = UserDefaults.standard.data(forKey: currentSessionUserModelKey),
           let decoded = try? decoder.decode(UserModel.self, from: savedUser) {
            self.user = decoded
        }
    }
    
    func updateUser(user: UserModel) {
        self.user = user
        if let encoded = try? encoder.encode(self.user) {
            UserDefaults.standard.set(encoded, forKey: currentSessionUserModelKey)
        }
    }
    
    func invalidateUser() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: currentSessionUserModelKey)
    }
}
