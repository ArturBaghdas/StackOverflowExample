import SwiftUI
import ComposableArchitecture
import APIClient

public struct QuestionsView: View {
    private var store: Store<QuestionsState, QuestionsAction>
    
    public init(store: Store<QuestionsState, QuestionsAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                List {
                    ForEachStore(
                        store.scope(
                            state: \.items,
                            action: QuestionsAction.questionItem(id:action:)
                        )
                    ) { itemStore in
                        QuestionItemView(store: itemStore)
                    }
                    
                    if viewStore.hasMoreData {
                        Text("Loading more...")
                            .onAppear { viewStore.send(.fetchNextPage) }
                    }
                }
            }
            .onAppear {
                viewStore.send(.fetchNextPage)
            }
            .navigationBarTitle(viewStore.tag, displayMode: .inline)
        }
    }
}

// MARK: - List Item View
private struct QuestionItemView: View {
    let store: Store<QuestionItem, QuestionItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text(viewStore.title)
                        .font(.headline)
                    
                    Text(viewStore.link)
                        .foregroundColor(.blue)
                        .font(.footnote)
                        .onTapGesture {
                            viewStore.send(.itemTapped)
                        }
                }
                
                Spacer()
                
                Text("\(viewStore.score)")
                    .font(.headline)
            }
            .padding(4)
        }
    }
}

