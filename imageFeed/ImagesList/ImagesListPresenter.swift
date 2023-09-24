import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func animatedUpdateTableView()
    func fetchNextPagePhotos()
    func cellHeight(
        indexPath: IndexPath,
        tableViewWidth: CGFloat) -> CGFloat
    func fetchNextPhotos(indexPath: IndexPath)
    func photosCount() -> Int
    func settingLike(for picture: Photo)
    func getLargeURL(from indexPath: IndexPath) -> URL
    func imagesListConfig()
    func getThumbURL(indexPath: IndexPath) -> String
       
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - Properties:
    weak var view: ImagesListViewControllerProtocol?
    
    // MARK: - Private properties:
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Methods:
    func animatedUpdateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        self.photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func fetchNextPagePhotos() {
        <#code#>
    }
    
    func cellHeight(
        indexPath: IndexPath,
        tableViewWidth: CGFloat
    ) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func fetchNextPhotos(indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func settingLike(for picture: Photo) {
        <#code#>
    }
    
    func getLargeURL(from indexPath: IndexPath) -> URL {
        let imageURL = URL(string: photos[indexPath.row].largeImageURL)
    }
    
    func imagesListConfig() {
        imagesListService.fetchPhotosNextPage()
        view?.addingObserver()
    }
    
    func getThumbURL(indexPath: IndexPath) -> String {
        photos[indexPath.row].thumbImageURL
    }
}
