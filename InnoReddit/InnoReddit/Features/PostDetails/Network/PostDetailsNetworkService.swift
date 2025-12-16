//
//  PostDetailsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

protocol PostDetailsNetworkServiceProtocol: AnyObject {
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO
}

final class PostDetailsNetworkService: BaseAPIClient { }

extension PostDetailsNetworkService: PostDetailsNetworkServiceProtocol {
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO {
        let response: SubredditDTO = try await self.sendRequest(path: "/r/\(subredditName)/about", httpMethod: .GET)
        return response
    }
}
