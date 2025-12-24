//
//  AuthenticationNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 24.12.25.
//

protocol AuthenticationNetworkServiceProtocol: AnyObject {
    func getUserInfo() async throws(APIError) -> UserMeInfoDTO
}

final class AuthenticationNetworkService: BaseAPIClient { }

extension AuthenticationNetworkService: AuthenticationNetworkServiceProtocol {
    func getUserInfo() async throws(APIError) -> UserMeInfoDTO {
        return try await self.sendRequest(path: "/api/v1/me", httpMethod: .GET)
    }
}
