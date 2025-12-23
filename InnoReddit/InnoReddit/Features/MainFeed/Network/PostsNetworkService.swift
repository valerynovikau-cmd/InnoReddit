//
//  PostsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation
import Factory

protocol PostsNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws(APIError) -> ListingDTO
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO
    func updatePost(postName: String) async throws(APIError) -> PostDTO
}

final class PostsNetworkService: BaseAPIClient { }

extension PostsNetworkService: PostsNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws(APIError) -> ListingDTO {
        var queryParams: [String: String] = [
            "raw_json" : "1"
        ]
        if let after = after {
            queryParams["after"] = after
        }
        let response: ListingDTO = try await self.sendRequest(path: category.urlPath, httpMethod: .GET, queryParams: queryParams)
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
