import Foundation

final class OAuth2Service {
    // MARK: - Properties:
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private let storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    var isAuthenticated: Bool {
        storage.token != nil
    }
    // MARK: - Methods:
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            assert(Thread.isMainThread)
            
            if lastCode == code { return }
            task?.cancel()
            lastCode = code
            
            guard let request = authTokenRequest(code: code) else {
                return assertionFailure("Невозможно сформировать запрос!")}
            object(for: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }
            }
        }
}
// MARK: - Extensions:
private extension OAuth2Service {
    func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                completion(result)
                self?.task = nil
            }
            self.task = task
            task.resume()
        }
    
    func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURLString: Constants.baseURLString
        ) }
}

