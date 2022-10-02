import Foundation
import ComposableArchitecture
import APIClient

// MARK: - Environment
public struct QuestionsEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var stackOverflowAPI: StackOverflowAPIProtocol
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        stackOverflowAPI: StackOverflowAPIProtocol
    ) {
        self.mainQueue = mainQueue
        self.stackOverflowAPI = stackOverflowAPI
    }
}
