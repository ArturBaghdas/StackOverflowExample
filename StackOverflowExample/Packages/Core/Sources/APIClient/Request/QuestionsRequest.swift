import Foundation

public struct QuestionsRequest {
    struct FetchData: APIRequestable {
        typealias ResponseType = QuestionsResponse
        
        public let key = "rX2Dmu2t3xpB*6FAy8PdhQ(("
        public let site = "stackoverflow"
        public let order = "desc"
        public let sort = "votes"
        public var page: Int
        public var pageSize: Int
        public var tagged: String
        
        var path: String {
            return "questions"
        }
        
        var method: HTTPMethod {
            return .GET
        }
        
        enum CodingKeys: String, CodingKey {
            case key
            case site
            case page
            case pageSize
            case order
            case sort
            case tagged
        }
    }
}
