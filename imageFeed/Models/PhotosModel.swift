import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Double
    let height: Double
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool

    init(profileResult: PhotoResult) {
        self.id = profileResult.id
        self.size = CGSize(width: profileResult.width, height: profileResult.height)
        self.createdAt = profileResult.createdAt.dateFromString
        self.welcomeDescription = profileResult.description
        self.thumbImageURL = profileResult.urls.thumb
        self.largeImageURL = profileResult.urls.full
        self.isLiked = profileResult.likedByUser
    }
}
