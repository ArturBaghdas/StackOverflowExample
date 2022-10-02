import Foundation
import APIClient

// MARK: - Actions
public enum QuestionsAction: Equatable {
    case onAppear
    case fetchNextPage
    case fetchNextPageResponse(response: Result<QuestionsResponse, StackOverflowAPIError>)
    case questionItem(id: UUID, action: QuestionItemAction)
}

public enum QuestionItemAction: Equatable {
    case itemTapped
}
