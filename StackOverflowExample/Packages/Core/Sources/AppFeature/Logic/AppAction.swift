import Foundation
import TagsFeature

// MARK: - Actions
public enum AppAction: Equatable {
    case tags(action: TagsAction)
}
