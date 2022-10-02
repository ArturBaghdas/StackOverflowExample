import Foundation

struct TagsRequest {
    struct FetchData: APIRequestable {
        typealias ResponseType = TagsResponse
        
        let key = "rX2Dmu2t3xpB*6FAy8PdhQ(("
        let site = "stackoverflow"
        var page: Int
        var pageSize: Int
        
        var path: String {
            return "tags"
        }
        
        var method: HTTPMethod {
            return .GET
        }
        
        enum CodingKeys: String, CodingKey {
            case page = "page"
            case pageSize = "pageSize"
            case key = "key"
            case site = "site"
        }
    }
}
