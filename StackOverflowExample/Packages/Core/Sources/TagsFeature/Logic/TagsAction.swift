import Foundation
import APIClient
import QuestionsFeature

// MARK: - Actions
public enum TagsAction: Equatable {
    case onAppear
    case fetchNextPage
    case fetchNextPageResponse(response: Result<TagsResponse, StackOverflowAPIError>)
    case tagItem(id: UUID, action: TagItemAction)
    case dismissQuestionsPage
    case question(action: QuestionsAction)
}

public enum TagItemAction: Equatable {
    case itemTapped
}
