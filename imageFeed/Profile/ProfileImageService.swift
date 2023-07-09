import Foundation

struct UserResult: Codable {
    let profileImage: String
}

final class ProfileImageService {
    // MARK: - Properties:
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private (set) var avatarURL: String?
    // MARK: - Methods:
    func fetchImageURL(username: String, _ completion: @escaping (Result<String,Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().token else { return }
        if lastToken == token { return }
        task?.cancel()
        
        let request = imageRequest(username: username, token: token)
        object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                let profileImageURL = profile.profileImage
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
    private func imageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET", baseURL: DefaultBaseURL!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
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

