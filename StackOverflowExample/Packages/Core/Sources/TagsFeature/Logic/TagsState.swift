import Foundation
import ComposableArchitecture
import APIClient
import QuestionsFeature

// MARK: - State
public struct TagsState: Equatable {
    public init(
        items: IdentifiedArrayOf<TagItem> = [],
        currentPage: Int = 0,
        isFetchingItems: Bool = false,
        hasMoreData: Bool = true,
        pageSize: Int = 10,
        question: QuestionsState? = nil
    ) {
        self.items = items
        self.currentPage = currentPage
        self.isFetchingItems = isFetchingItems
        self.hasMoreData = hasMoreData
        self.pageSize = pageSize
        self.question = question
    }
    
    public var items: IdentifiedArrayOf<TagItem>
    public var currentPage: Int
    public var isFetchingItems: Bool
    public var hasMoreData: Bool
    public let pageSize: Int
    public var selectedTag: String?
    public var question: QuestionsState?

    public var showQuestionsPage: Bool {
        question != nil
    }
}
