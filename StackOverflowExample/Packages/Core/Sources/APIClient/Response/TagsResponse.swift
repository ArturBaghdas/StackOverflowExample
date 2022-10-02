import Foundation

public struct TagsResponse: Decodable, Equatable {
    public var quotaMax: Int
    public var quotaRemaining: Int
    public var hasMore: Bool
    public var items: [TagItem]
    
    enum CodingKeys: String, CodingKey {
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
        case hasMore = "has_more"
        case items
    }
}

public struct TagItem: Decodable, Equatable, Identifiable {
    public var id: UUID = UUID()
    public var name: String
    public var isModeratorOnly: Bool
    public var isRequired: Bool
    public var count: Int
    public var hasSynonyms: Bool
    
    public init(
        name: String,
        isModeratorOnly: Bool,
        isRequired: Bool,
        count: Int,
        hasSynonyms: Bool
    ) {
        self.name = name
        self.isModeratorOnly = isModeratorOnly
        self.isRequired = isRequired
        self.count = count
        self.hasSynonyms = hasSynonyms
    }
        
    enum CodingKeys: String, CodingKey {
        case name
        case isModeratorOnly = "is_moderator_only"
        case isRequired = "is_required"
        case hasSynonyms = "has_synonyms"
        case count
    }
}
