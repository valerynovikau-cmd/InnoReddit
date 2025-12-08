//
//  PostsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import Foundation
import Factory

protocol PostsNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws(APIError) -> ListingResponseDTO
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditResponseDTO
    func getPostScoreAndCommentCount(postName: String) async throws(APIError) -> (score: Int, commentCount: Int)
}

final class PostsNetworkService: BaseAPIClient { }

extension PostsNetworkService: PostsNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws(APIError) -> ListingResponseDTO {
        var queryParams: [String: String] = [
            "raw_json" : "1"
        ]
        if let after = after {
            queryParams["after"] = after
        }
        let response: ListingResponseDTO = try await self.sendRequest(path: category.urlPath, httpMethod: .GET, queryParams: queryParams)
        return response
    }
    
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditResponseDTO {
        let response: SubredditResponseDTO = try await self.sendRequest(path: "/r/\(subredditName)/about", httpMethod: .GET)
        return response
    }
    
    func getPostScoreAndCommentCount(postName: String) async throws(APIError) -> (score: Int, commentCount: Int) {
        let response: ListingResponseDTO = try await self.sendRequest(path: "/by_id/\(postName)", httpMethod: .GET)
        guard let post = response.data.children.first?.data else {
            throw .invalidResponse
        }
        return (post.score, post.numComments)
    }
}
