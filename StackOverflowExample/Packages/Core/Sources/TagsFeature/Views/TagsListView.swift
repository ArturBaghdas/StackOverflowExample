import SwiftUI
import ComposableArchitecture
import APIClient
import QuestionsFeature

public struct TagsListView: View {
    private var store: Store<TagsState, TagsAction>
    private var viewStore: ViewStore<TagsState, TagsAction>

    public init(store: Store<TagsState, TagsAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                List {
                    ForEachStore(
                        store.scope(
                            state: \.items,
                            action: TagsAction.tagItem(id:action:)
                        )
                    ) { itemStore in
                        TagListItemView(store: itemStore)
                    }
                    
                    if viewStore.hasMoreData {
                        Text("Loading more...")
                            .onAppear { viewStore.send(.fetchNextPage) }
                    }
                }.listStyle(.plain)
                questionsNavigationLinkView
            }
            .navigationBarTitle("Tags", displayMode: .inline)
        }
    }
    
    private var questionsNavigationLinkView: some View {
        NavigationLink(
            destination: IfLetStore(
                self.store.scope(
                    state: \.question,
                    action: TagsAction.question(action:)
                ),
                then: QuestionsView.init(store:)
            ),
            isActive: viewStore.binding(
                get: \.showQuestionsPage,
                send: TagsAction.dismissQuestionsPage
            ),
            label: {
                EmptyView()
            }
        ).hidden()
    }
}

// MARK: - List Item View
struct TagListItemView: View {
    let store: Store<TagItem, TagItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            Button {
                viewStore.send(.itemTapped)
            } label: {
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(viewStore.name)
                            .font(.headline)
                        Text("\(viewStore.count)")
                            .font(.footnote)
                    }
                }
                .frame(height: 60)
            }
        }
    }
}

