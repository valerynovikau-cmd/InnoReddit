//
//  PostDetailsNetworkService.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 8.12.25.
//

protocol PostDetailsNetworkServiceProtocol: AnyObject {
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO
    func sendVote(vote: ScoreDirection, id: String) async throws(APIError)
}

enum ScoreDirection: String {
    case down = "-1"
    case none = "0"
    case up = "1"
}

final class PostDetailsNetworkService: BaseAPIClient { }

extension PostDetailsNetworkService: PostDetailsNetworkServiceProtocol {
    func getSubredditIconURL(subredditName: String) async throws(APIError) -> SubredditDTO {
        let response: SubredditDTO = try await self.sendRequest(path: "/r/\(subredditName)/about", httpMethod: .GET)
        return response
    }
    
    func sendVote(vote: ScoreDirection, id: String) async throws(APIError) {
        let body: [String: String] = [
            "dir": vote.rawValue,
            "id": id
        ]
        let _ : EmptyResponseDTO = try await self.sendRequest(path: "api/vote", httpMethod: .POST, body: .urlEncodedBody(body))
    }
}
