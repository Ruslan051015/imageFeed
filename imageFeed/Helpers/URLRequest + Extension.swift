import Foundation

final class URLRequestBuilder {
    // MARK: - Properties:
    static let shared = URLRequestBuilder()
    private let storage = OAuth2TokenStorage.shared
    // MARK: - Merhods:
    func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL
    ) -> URLRequest? {
        guard let basicURL = URL(string: path, relativeTo: baseURL)
        else { return nil }
        
        var request = URLRequest(url: basicURL)
        request.httpMethod = httpMethod
        
        if let token = storage.token {
            request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        }
     return request
    }
}
