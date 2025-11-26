//
//  APIError.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 25.11.25.
//

enum APIError: Error {
    case networkError(statusCode: Int)
    case APIErrorMessage(message: String)
    case invalidResponse
    case invalidRequest
    case storedCredentialsError
    case parsingError(Error)
    case unknown
    
    @MainActor var errorMessage: String {
        var messageFirstPart: String = ""
        switch self {
        case .APIErrorMessage(let message):
            messageFirstPart = APIErrorStrings.apiErrorMessage + " \(message)"
        case .invalidRequest:
            messageFirstPart = APIErrorStrings.invalidRequest
        case .invalidResponse:
            messageFirstPart = APIErrorStrings.invalidResponse
        case .networkError(let statusCode):
            messageFirstPart = APIErrorStrings.networkError + " \(statusCode)"
        case .parsingError:
            messageFirstPart = APIErrorStrings.parsingError
        case .storedCredentialsError:
            messageFirstPart = APIErrorStrings.storedCredentialsError
        case .unknown:
            messageFirstPart = APIErrorStrings.unknown
        default:
            messageFirstPart = APIErrorStrings.unknown
        }
        return messageFirstPart + " " + APIErrorStrings.tryAgainText
    }
    
    @MainActor var errorTitle: String {
        return APIErrorStrings.errorTitle
    }
}
