import SwiftUI
import ComposableArchitecture
import TagsFeature

public struct AppView: View {
    private let store: Store<AppState, AppAction>
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            TagsListView(
                store: store.scope(
                    state: { $0.tags },
                    action: AppAction.tags
                )
            )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: .init(
                    tags: .init()
                ),
                reducer: .empty,
                environment: ()
            )
        )
    }
}
