import Foundation

final class ImageListService {
    // MARK: - Private Properties:
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let token  = OAuth2TokenStorage.shared.token
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name("ImagesListServiceDidChange")
    // MARK: - Methods
    private func fetchPhotosNextPage() {
        guard task == nil else { return }
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = profileRequest(page: nextPage) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        object(for: request) { [weak self] result in
            guard let self = self else {
                assertionFailure("Скорее всего деинит")
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    photoResult.forEach { photo in
                        self.photos.append(Photo(profileResult: photo))
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImageListService.DidChangeNotification, object: self)
                    
                case .failure(let error):
                    assertionFailure("Не удалось сохранить фото в массив")
                }
            }
        }
    }
    // MARK: - Private Methods:
    private func profileRequest(page: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "popular")]
        var url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                completion(result)
                self?.task = nil
            }
            self.task = task
            task.resume()
        }
}


