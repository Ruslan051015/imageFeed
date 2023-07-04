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
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error  in
            guard let self = self else { return }
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode,
               200...300 ~= statusCode {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let imageData = try? decoder.decode(UserResult.self, from: data) else { return }
                DispatchQueue.main.async {
                    let profileImageURL = imageData.profileImage
                    completion(.success(profileImageURL))
                    NotificationCenter.default
                        .post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": profileImageURL])
                    self.task = nil
                    self.avatarURL = profileImageURL
                }
            } else if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self.lastToken = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods:
    private func imageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "users/:\(username)", httpMethod: "GET", baseURL: DefaultBaseURL!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

