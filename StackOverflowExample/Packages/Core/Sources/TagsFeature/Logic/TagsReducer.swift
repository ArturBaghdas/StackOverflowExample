import Foundation
import ComposableArchitecture
import APIClient
import QuestionsFeature

// MARK: - Reducer
public let tagsReducer = Reducer<TagsState, TagsAction, TagsEnvironment>.combine(
    tagItemReducer.forEach(
        state: \TagsState.items,
        action: /TagsAction.tagItem(id:action:),
        environment: { _ in () }
    ),
    questionsReducer
        .optional()
        .pullback(
            state: \.question,
            action: /TagsAction.question(action:),
            environment: { .init(
                mainQueue: $0.mainQueue,
                stackOverflowAPI: $0.stackOverflowAPI
            )
            }
        ),
    Reducer<TagsState, TagsAction, TagsEnvironment> { state, action, environment in
        switch action {
        case .onAppear:
            return Effect(value: .fetchNextPage)
            
        case .fetchNextPage:
            if state.hasMoreData && !state.isFetchingItems {
                state.isFetchingItems = true
                let nextPage = state.currentPage + 1
                
                return environment.stackOverflowAPI.fetchTagsData(page: nextPage, pageSize: state.pageSize)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(TagsAction.fetchNextPageResponse)
            }
            return .none
            
        case let .fetchNextPageResponse(.success(response)):
            state.currentPage = state.currentPage + 1
            state.hasMoreData = response.hasMore
            state.items.append(contentsOf: response.items)
            state.isFetchingItems = false
            return .none
            
        case let .fetchNextPageResponse(.failure(error)):
            state.isFetchingItems = false
            // TODO: handle error
            return .none
            
        case .dismissQuestionsPage:
            state.question = nil
            return .none
            
        case .tagItem(let id, action: .itemTapped):
            if let tag = state.items[id: id] {
                state.question = QuestionsState(tag: tag.name)
            }
            return .none
            
        case .tagItem:
            return .none
            
        case .question:
            return .none
        }
    }
)

public let tagItemReducer = Reducer<TagItem, TagItemAction, Void> { state, action, environment in
    switch action {
    case .itemTapped:
        return .none
    }
}
