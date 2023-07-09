import Foundation
import UIKit

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

final class ProfileService {
    // MARK: - Properties:
    static let shared = ProfileService()
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
        object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                if case URLSession.NetworkError.urlSessionError = error {
                    self.lastToken = nil
                }
            }
        }
    }
    // MARK: - Private Methods:
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", baseURL: DefaultBaseURL!)
        request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        return request
    }
    func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                completion(result)
                self?.task = nil
            }
            self.task = task
            task.resume()
        }
}
