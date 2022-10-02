import Foundation

public class StackOverflowAPIClient: APIClient {
    private let baseUrlString = "https://api.stackexchange.com/2.3/"
    
    public init() {
        super.init(baseUrl: URL(string: baseUrlString)!)
    }
}
