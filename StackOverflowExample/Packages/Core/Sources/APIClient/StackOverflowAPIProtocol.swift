import Foundation
import Combine

public protocol StackOverflowAPIProtocol {
    func fetchTagsData(
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<TagsResponse, StackOverflowAPIError>
    
    func fetchQuestionsData(
        for tag: String,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<QuestionsResponse, StackOverflowAPIError>
}

public enum StackOverflowAPIError: Error, Equatable {
    case badRequest
}

extension StackOverflowAPIClient: StackOverflowAPIProtocol {
    public func fetchTagsData(
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<TagsResponse, StackOverflowAPIError> {
        let request = TagsRequest.FetchData(page: page, pageSize: pageSize)
        return send(requestable: request)
            .tryMap { response in
                guard let data = response.object, response.statusCode == 200 else {
                    throw StackOverflowAPIError.badRequest
                }
                return data
            }
            .mapError { error in
                return StackOverflowAPIError.badRequest
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchQuestionsData(
        for tag: String,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<QuestionsResponse, StackOverflowAPIError> {
        let request = QuestionsRequest.FetchData(page: page, pageSize: pageSize, tagged: tag)
        return send(requestable: request)
            .tryMap { response in
                guard let data = response.object, response.statusCode == 200 else {
                    throw StackOverflowAPIError.badRequest
                }
                return data
            }
            .mapError { error in
                return StackOverflowAPIError.badRequest
            }
            .eraseToAnyPublisher()
    }
}
