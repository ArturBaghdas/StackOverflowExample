import Foundation
import ComposableArchitecture
import APIClient
import UIKit

// MARK: - Reducer
public let questionsReducer = Reducer<QuestionsState, QuestionsAction, QuestionsEnvironment>.combine(
    questionItemReducer.forEach(
        state: \.items,
        action: /QuestionsAction.questionItem(id:action:),
        environment: { _ in }
    ),
    Reducer<QuestionsState, QuestionsAction, QuestionsEnvironment> { state, action, environment in
        switch action {
            
        case .onAppear:
            return Effect(value: .fetchNextPage)
            
        case .fetchNextPage:
            if state.hasMoreData && !state.isFetchingItems {
                state.isFetchingItems = true
                let nextPage = state.currentPage + 1
                
                return environment.stackOverflowAPI.fetchQuestionsData(
                    for: state.tag,
                    page: nextPage,
                    pageSize: state.pageSize
                )
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(QuestionsAction.fetchNextPageResponse)
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
            
        case .questionItem:
            return .none
        }
    }
)

public let questionItemReducer = Reducer<QuestionItem, QuestionItemAction, Void> { state, action, _ in
    switch action {
    case .itemTapped:
        UIApplication.shared.open(URL(string: state.link)!)
        return .none
    }
}

