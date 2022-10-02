import SwiftUI
import ComposableArchitecture
import APIClient
import TagsFeature
import AppFeature

@main
struct StackOverflowExampleApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppState(
                        tags: TagsState()
                    ),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        stackOverflowAPI: StackOverflowAPIClient()
                    )
                )
            )
        }
    }
}
