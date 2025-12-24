//
//  ProfilePostsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import Foundation
import Factory

protocol ProfilePostsNetworkServiceProtocol {
    func getPosts(after: String?, category: ProfilePostsCategory) async throws(APIError) -> ListingDTO
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO
    func updatePost(postName: String) async throws(APIError) -> PostDTO
}

final class ProfilePostsNetworkService: BaseAPIClient { }

extension ProfilePostsNetworkService: ProfilePostsNetworkServiceProtocol {
    func getPosts(after: String?, category: ProfilePostsCategory) async throws(APIError) -> ListingDTO {
        var queryParams: [String: String] = [
            "raw_json" : "1"
        ]
        if let after = after {
            queryParams["after"] = after
        }
        let response: ListingDTO = try await self.sendRequest(path: "/user/badkrasotka\(category.urlPath)", httpMethod: .GET, queryParams: queryParams)
        return response
    }
    
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO {
        let response: SubredditDTO = try await self.sendRequest(path: "/r/\(subredditName)/about", httpMethod: .GET)
        return response
    }
    
    func updatePost(postName: String) async throws(APIError) -> PostDTO {
        let response: ListingDTO = try await self.sendRequest(path: "/by_id/\(postName)", httpMethod: .GET)
        guard let post = response.data.children.first?.data else {
            throw .invalidResponse
        }
        return post
    }
}
