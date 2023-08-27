import Foundation
import UIKit

final class ProfileService {
    // MARK: - Properties:
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private (set) var profile: Profile?
    // MARK: - Methods:
    func fetchProfile(completion: @escaping (Result<Profile,Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
       guard let request = profileRequest() else {
           return assertionFailure("Невозможно сформировать запрос!")}
        
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
    private func profileRequest() -> URLRequest? {
        builder.makeHTTPRequest(path: "/me",
                                httpMethod: "GET",
                                baseURLString: Constants.defaultApiBaseURLString)}
    
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

