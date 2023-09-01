import Foundation

final class ImagesListService {
    // MARK: - Private Properties:
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name("ImagesListServiceDidChange")
    // MARK: - Methods
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = profileRequest(page: nextPage) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        object(for: request) { result in
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
        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
    }
    // MARK: - Private Methods:
    private func profileRequest(page: Int) -> URLRequest? {
       var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComponents.queryItems = [
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "order_by", value: "popular")]
        var url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(request)
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


