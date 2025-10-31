//
//  LogInWithRedditUseCase.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 30.10.25.
//

protocol LogInWithRedditUseCaseProtocol: AnyObject {
    func execute()
}

final class LogInWithRedditUseCase: LogInWithRedditUseCaseProtocol {
    private let authenticationRepository: AuthenticationRepositoryProtocol
    
    init(authenticationRepository: AuthenticationRepositoryProtocol) {
        self.authenticationRepository = authenticationRepository
    }
    
    func execute() {
        
    }
}
