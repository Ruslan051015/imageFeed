import Foundation

final class ProfileImageService {
    // MARK: - Properties:
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    // MARK: - Private properties:
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private let storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private (set) var avatarURL: String?
    private let authParams = AuthConfiguration.standard
    
    // MARK: - Methods:
    func fetchImageURL(username: String, _ completion: @escaping (Result<String,Error>) -> Void) {
        assert(Thread.isMainThread)
        guard
            let token = storage.token,
            lastToken != token
        else { return }
        task?.cancel()
        lastToken = token
        
        guard let request = imageRequest(username: username, token: token) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        
        object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                guard  let profileImageURL = profile.profileImage.medium else {
                    assertionFailure("Не удалось получить url профиля")
                    return
                }
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                completion(.failure(error))
                if case URLSession.NetworkError.urlSessionError = error {
                    self.lastToken = nil
                }
            }
        }
    }
    
    // MARK: - Private methods:
    private func imageRequest(username: String, token: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: authParams.defaultBaseApiURL)
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                completion(result)
                self?.task = nil
            }
            self.task = task
            task.resume()
        }
}

