//
//  MockPostsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 10.12.25.
//

import Foundation

final class MockPostsNetworkService: BaseAPIClient { }

extension MockPostsNetworkService: PostsNetworkServiceProtocol {
    func getPosts(after: String?, category: MainFeedCategory) async throws(APIError) -> ListingResponseDTO {
        var queryParams: [String: String] = [
            "raw_json" : "1"
        ]
        if let after = after {
            queryParams["after"] = after
        }
        let path = "/by_id/t3_1pic6xp,t3_1i6tu6v,t3_1ovr9k6,t3_1pj006r"
        let response: ListingResponseDTO = try await self.sendRequest(path: path, httpMethod: .GET, queryParams: queryParams)
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
