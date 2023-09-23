import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

public protocol ImagesListViewControllerProtocol {
    
}

final class ImagesListViewController: UIViewController {
    //MARK: - Properties:
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - IBOutlets:
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties:
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imageListObserver: NSObjectProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private var alertPresenter: AlertPresenter?
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        
        imagesListService.fetchPhotosNextPage()
        imageListObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: imagesListService,
                         queue: .main) {  _ in
                self.updateTableViewAnimated()
            }
    }
    
    //MARK: - Methods:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
            viewController.largeURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        if oldCount != newCount {
            tableView.performBatchUpdates {
                self.photos = imagesListService.photos
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - Private methods:
func showError() {
    let alert = AlertModel(title: "Ошибка", message: "Не удалось установить лайк!", buttonText: "OK", completion: { [weak self] in
        guard let self = self else { return }
        
    })
}

//MARK: - Extensions:
extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не удалось создать объект ImagesListCell")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        let isCellConfigured = imageListCell.configCell(
            with: photos[indexPath.row].thumbImageURL,
            with: indexPath)
        
        imageListCell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
        if isCellConfigured {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return imageListCell
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
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
                    let alert = UIAlertController(title: "Ошибка", message: "Ну удалось установить лайк!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
    }
}

extension ImagesListViewController: AlertPresenterDelegate {
    func present(view: UIAlertController, animated: Bool) {
        view.present(view, animated: animated)
    }
    
    
}
