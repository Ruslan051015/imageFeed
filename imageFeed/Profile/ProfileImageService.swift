import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
}
struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

final class ProfileImageService {
    // MARK: - Properties:
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let builder: URLRequestBuilder
    private let storage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private (set) var avatarURL: String?
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    // MARK: - Methods:
    func fetchImageURL(username: String, _ completion: @escaping (Result<String,Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = storage.token else { return }
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        guard let request = imageRequest(username: username, token: token) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        
        object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                guard  let profileImageURL = profile.profileImage.medium else {
                    assertionFailure("Can't get image url")
                    return
                }
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": avatarURL!])
            case .failure(let error):
                completion(.failure(error))
                if case URLSession.NetworkError.urlSessionError = error {
                    self.lastToken = nil
                }
            }
        }
    }
    
    // MARK: - Private Methods:
    private func imageRequest(username: String, token: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURLString: Constants.defaultApiBaseURLString)
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

