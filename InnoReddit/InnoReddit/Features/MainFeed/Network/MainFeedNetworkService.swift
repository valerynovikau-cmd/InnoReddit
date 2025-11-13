//
//  MainFeedNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation
import Factory

enum MainFeedCategory: String {
    case best = "/best"
    case hot = "/hot"
    case new = "/new"
    case top = "/top"
    case rising = "/rising"
}

protocol MainFeedNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws -> ListingResponseDTO
}

final class MainFeedNetworkService: MainFeedNetworkServiceProtocol {
    var baseURL: URL = URL(string: "https://oauth.reddit.com")!
    @Injected(\.tokenStorageRepository) var tokenStorageRepository: TokenStorageRepositoryProtocol
    
    func getPosts(after: String?, category: MainFeedCategory) async throws -> ListingResponseDTO {
        var queryParams: [String: String] = [:]
        if let after = after {
            queryParams["after"] = after
        }
        let response: ListingResponseDTO = try await self.sendRequest(path: category.rawValue, httpMethod: .GET, queryParams: queryParams)
        return response
    }
}

extension MainFeedNetworkService: APIClient {
    func send(request: URLRequest) async throws -> APIResponse {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        return APIResponse(statusCode: httpResponse.statusCode, data: data)
    }
    
    func onTokenRefreshed(response: TokenRetrievalDTO) throws {
        guard let refreshToken = response.refreshToken else {
            throw APIError.invalidResponse
        }
        try self.tokenStorageRepository.saveTokens(
            accessToken: response.accessToken,
            refreshToken: refreshToken
        )
    }
    
    func defaultHeaders(additionalHeaders: [String : String]) throws -> [String : String] {
        var dict: [String:String] = [:]
        let accessToken = try self.tokenStorageRepository.getToken(tokenAccessType: .accessToken)
        guard let userAgent = Bundle.main.infoDictionary?["User-Agent"] as? String else {
            throw NSError()
        }
        
        dict["User-Agent"] = userAgent
        dict["Authorization"] = "Bearer \(accessToken)"
        for (key, value) in additionalHeaders {
            dict[key] = value
        }
        return dict
    }
    
    func getRefreshToken() throws -> String {
        return try self.tokenStorageRepository.getToken(tokenAccessType: .refreshToken)
    }
}
