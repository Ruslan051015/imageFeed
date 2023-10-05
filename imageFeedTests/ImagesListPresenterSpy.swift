import imageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: imageFeed.ImagesListViewControllerProtocol?
    var imagesListConfigWasCalled: Bool = false
    
    func animatedUpdateTableView() {
        
    }
    
    func cellHeight(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        CGFloat()
    }
    
    func fetchNextPhotos(indexPath: IndexPath) {
        
    }
    
    func getPhoto(indexPath: IndexPath) -> imageFeed.Photo? {
        return nil
    }
    
    func getLargeURL(from indexPath: IndexPath) -> URL? {
        return nil
    }
    
    func imagesListConfig() {
        imagesListConfigWasCalled = true
    }
    
    func settingLike(for cell: imageFeed.ImagesListCell, indexPath: IndexPath) {
        
    }
    
    func photosCount() -> Int {
        return 0
    }
    
    
}
