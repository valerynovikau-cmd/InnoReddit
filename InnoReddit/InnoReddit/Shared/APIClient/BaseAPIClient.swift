//
//  BaseAPIClient.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

import Foundation
import Factory

class BaseAPIClient {
    var baseURL: URL = URL(string: "https://oauth.reddit.com")!
    var tokensBaseURL: URL = URL(string: "https://www.reddit.com")!
    @Injected(\.tokenStorageRepository) var tokenStorageRepository: TokenStorageRepositoryProtocol
}

extension BaseAPIClient: APIClientProtocol {
    func send(request: URLRequest) async throws(APIError) -> APIResponse {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            return APIResponse(statusCode: httpResponse.statusCode, data: data)
        } catch {
            throw .invalidResponse
        }
    }
    
    func onTokenRefreshed(response: TokenRetrievalDTO) throws(APIError) {
        guard let refreshToken = response.refreshToken else {
            throw APIError.invalidResponse
        }
        
        do {
            return try self.tokenStorageRepository.saveTokens(
                accessToken: response.accessToken,
                refreshToken: refreshToken
            )
        } catch {
            throw .storedCredentialsError
        }
    }
    
    func defaultHeaders(additionalHeaders: [String : String]) throws(APIError) -> [String : String] {
        var dict: [String:String] = [:]
        guard let accessToken = try? self.tokenStorageRepository.getToken(tokenAccessType: .accessToken),
              let userAgent = ConfigParameterManager.userAgent
        else {
            throw .storedCredentialsError
        }
        
        dict["User-Agent"] = userAgent
        dict["Authorization"] = "Bearer \(accessToken)"
        for (key, value) in additionalHeaders {
            dict[key] = value
        }
        return dict
    }
    
    func getRefreshToken() throws(APIError) -> String {
        do {
            return try self.tokenStorageRepository.getToken(tokenAccessType: .refreshToken)
        } catch {
            throw .storedCredentialsError
        }
    }
}
