import Foundation

final class ImagesListService {
    // MARK: - Private Properties:
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let builder = URLRequestBuilder.shared
    private let token = OAuth2TokenStorage.shared.token
    private var imageListTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    static let DidChangeNotification = Notification.Name("ImagesListServiceDidChange")
    // MARK: - Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard imageListTask == nil else { return }
        imageListTask?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = profileRequest(page: nextPage) else {
            return assertionFailure("Невозможно сформировать запрос!")}
        object(for: request) {  [weak self] result in
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
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self, userInfo: ["Photos": self.photos])
                    
                case .failure(let error):
                    print(error)
                    assertionFailure("Не удалось сохранить фото в массив")
                }
            }
        }
    }
    
    func changeLike(photoID: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>)-> Void) {
        assert(Thread.isMainThread)
        guard changeLikeTask == nil else { return }
        changeLikeTask?.cancel()
        
        guard let request: URLRequest = isLike ? unlikeRequest(photoID: photoID) : likeRequest(photoID: photoID) else {
            assertionFailure("Невозможно сформировать запрос!")
            return
        }
        print(request) //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        checkLikeStatus(for: request) { [weak self] result  in
            guard let self = self else {
                assertionFailure("Что-то пошло не так")
                return
            }
            DispatchQueue.main.async {
                switch result {
                case.success(let response):
                    let likedByUser = response.photo.likedByUser
                    print(likedByUser) //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    if let index = self.photos.firstIndex(where: { $0.id == photoID}) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: likedByUser)
                        self.photos[index] = newPhoto
                        print(newPhoto.self) //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    }
                    completion(.success(likedByUser))
                case .failure(let error):
                    completion(.failure(error))
                    assertionFailure("Не удалось получить статус лайка!")
                }
            }
        }
    }
    // MARK: - Private Methods:
    private func profileRequest(page: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "order_by", value: "popular")]
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func likeRequest(photoID: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/photos/\(photoID)/like",
                                httpMethod: "POST",
                                baseURLString: Constants.defaultApiBaseURLString)
        
    }
    
    private func unlikeRequest(photoID: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/photos/\(photoID)/like",
                                httpMethod: "DELETE",
                                baseURLString: Constants.defaultApiBaseURLString)
        
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                completion(result)
                self?.imageListTask = nil
            }
            self.imageListTask = task
            task.resume()
        }
    
    private func checkLikeStatus(
        for request: URLRequest,
        completion: @escaping (Result<LikedPhotoResult, Error>) -> Void) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikedPhotoResult, Error>) in
                completion(result)
                self?.changeLikeTask = nil
            }
            self.changeLikeTask = task
            task.resume()
        }
}
