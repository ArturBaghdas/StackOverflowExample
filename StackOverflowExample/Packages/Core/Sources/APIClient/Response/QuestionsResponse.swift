import Foundation

public struct QuestionsResponse: Decodable, Equatable {
    public var quotaMax: Int
    public var quotaRemaining: Int
    public var hasMore: Bool
    public var items: [QuestionItem]
    
    enum CodingKeys: String, CodingKey {
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
        case hasMore = "has_more"
        case items
    }
}

public struct QuestionItem: Decodable, Equatable, Identifiable {
    public var id: UUID = UUID()
    public var title: String
    public var link: String
    public var score: Int
        
    enum CodingKeys: String, CodingKey {
        case link
        case title
        case score
    }
}
