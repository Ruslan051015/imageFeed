import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func fetchNextPagePhotos()
    func updateTableView()
    func photosCount() -> Int
    
}
