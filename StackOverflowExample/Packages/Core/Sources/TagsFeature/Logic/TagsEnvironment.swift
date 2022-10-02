import Foundation
import ComposableArchitecture
import APIClient

// MARK: - Environment
public struct TagsEnvironment {
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        stackOverflowAPI: StackOverflowAPIProtocol
    ) {
        self.mainQueue = mainQueue
        self.stackOverflowAPI = stackOverflowAPI
    }
    
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var stackOverflowAPI: StackOverflowAPIProtocol
}
