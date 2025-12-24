//
//  ProfilePresenter.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 24.12.25.
//

import Factory

protocol ProfilePresenterProtocol: AnyObject {
    var input: ProfileViewProtocol? { get set }
    var router: AppRouterProtocol? { get set }
    func signOut()
}

final class ProfilePresenter {
    weak var input: ProfileViewProtocol?
    var router: AppRouterProtocol? = {
        Container.shared.appRouter(nil)
    }()
    
    @Injected(\.tokenStorageRepository) private var tokenStorageRepository: TokenStorageRepositoryProtocol
    @Injected(\.authSessionManager) private var authSessionManager: AuthSessionManagerProtocol
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func signOut() {
        do {
            try self.tokenStorageRepository.clearTokens()
            self.authSessionManager.invalidateUser()
            self.router?.showAuthenticationScreen()
        } catch { }
    }
}
