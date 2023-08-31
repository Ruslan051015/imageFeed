import Foundation

final class ImageListService {
    // MARK: - Private Properties:
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name("ImagesListServiceDidChange")
    // MARK: - Methods
    private func fetchPhotosNextPage() {
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = profileRequest(page: nextPage) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        object(for: request) { [weak self] result in
            guard let self = self else {
                assertionFailure("Класса уже нет, а мы используем его")
                return
            }
            switch result {
            case .success(let photoResult):
                let photo = Photo(profileResult: photoResult)
                DispatchQueue.main.async {
                    self.photos.append(photo)
                }
            case .failure(let error):
                assertionFailure("Не удалось сохранить фото в массив")
            }
        }
        lastLoadedPage = nextPage
        NotificationCenter.default.post(name: ImageListService.DidChangeNotification, object: self)
    }
    // MARK: - Private Methods:
    private func profileRequest(page: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultApiBaseURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "popular")]
        let url = urlComponents.url!
        
        let request = builder.makeHTTPRequest(path: "/photos",
                                              httpMethod: "GET",
                                              baseURLString: "\(url)")
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<PhotoResult, Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
                completion(result)
                self?.task = nil
            }
            self.task = task
            task.resume()
        }
}


