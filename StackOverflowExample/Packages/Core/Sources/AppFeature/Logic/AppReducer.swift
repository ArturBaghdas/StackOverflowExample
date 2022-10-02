import Foundation
import ComposableArchitecture
import TagsFeature

// MARK: - Reducer
public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    tagsReducer.pullback(
        state: \AppState.tags,
        action: /AppAction.tags,
        environment: {
            TagsEnvironment(
                mainQueue: $0.mainQueue,
                stackOverflowAPI: $0.stackOverflowAPI
            )
        }
    ),
    Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
        switch action {
        default:
            return .none
        }
    }
)
.debugActions()
