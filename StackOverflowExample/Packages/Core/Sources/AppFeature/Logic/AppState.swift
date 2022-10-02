import Foundation
import TagsFeature

// MARK: - State
public struct AppState: Equatable {
    public init(tags: TagsState) {
        self.tags = tags
    }
    
    public var tags: TagsState
}
