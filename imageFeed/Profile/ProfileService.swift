import Foundation
import UIKit

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profileImage: URL
}
struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "(@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

final class ProfileService {
    // MARK: - Properties:
    static let shared = ProfileService()
    private var bearerToken = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private (set) var profile: Profile?
    
    // MARK: - Methods:
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile,Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        
        let request = profileRequest(token: token)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode,
               200...300 ~= statusCode {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let profileData = try? decoder.decode(ProfileResult.self, from: data) else
                { return }
                DispatchQueue.main.async {
                    let profile = Profile(profileResult: profileData)
                    completion(.success(profile))
                    self?.profile = profile
                    self?.task = nil
                }
            } else if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self?.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    // MARK: - Private Methods:
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "me", httpMethod: "GET", baseURL: DefaultBaseURL!)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
