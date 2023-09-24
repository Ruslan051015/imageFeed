import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func animatedUpdateTableView()
    func cellHeight(
        indexPath: IndexPath,
        tableViewWidth: CGFloat) -> CGFloat
    func fetchNextPhotos(indexPath: IndexPath)
    func getPhoto(indexPath: IndexPath) -> Photo?
    func getLargeURL(from indexPath: IndexPath) -> URL?
    func imagesListConfig()
    func settingLike(for cell: ImagesListCell, indexPath: IndexPath)
    func photosCount() -> Int
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
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
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
    
    func settingLike(for cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        imagesListService.changeLike(
            photoID: photo.id,
            isLike: photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    view?.showLikeError()
                }
            }
    }
    
    func getLargeURL(from indexPath: IndexPath) -> URL? {
        URL(string: photos[indexPath.row].largeImageURL)
    }
    
    func imagesListConfig() {
        imagesListService.fetchPhotosNextPage()
        view?.addingObserver()
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        imagesListService.photos[indexPath.row]
    }
}
