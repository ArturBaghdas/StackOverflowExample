import Foundation
import ComposableArchitecture
import APIClient

// MARK: - State
public struct QuestionsState: Equatable {
    public init(
        items: IdentifiedArrayOf<QuestionItem> = [],
        currentPage: Int = 0,
        tag: String = "",
        isFetchingItems: Bool = false,
        hasMoreData: Bool = true,
        pageSize: Int = 10
    ) {
        self.items = items
        self.currentPage = currentPage
        self.tag = tag
        self.isFetchingItems = isFetchingItems
        self.hasMoreData = hasMoreData
        self.pageSize = pageSize
    }
    
    public var items: IdentifiedArrayOf<QuestionItem>
    public var currentPage: Int
    public var tag: String
    public var isFetchingItems: Bool
    public var hasMoreData: Bool
    public var pageSize: Int
}
