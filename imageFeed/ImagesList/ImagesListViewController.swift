import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func addingObserver()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    //MARK: - Properties:
    weak var presenter: ImagesListPresenterProtocol?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - IBOutlets:
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties:
    
    private var imageListObserver: NSObjectProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    //    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private var alertPresenter: AlertPresenter?
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        presenter?.view = self
        
        presenter?.imagesListConfig()
        
    }
    
    //MARK: - Methods:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.largeURL = presenter?.getLargeURL(from: indexPath)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
    }
    
    func addingObserver() {
        imageListObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.animatedUpdateTableView()
            }
    }
    
    // MARK: - Private methods:
    func showError() {
        let alert = AlertModel(title: "Ошибка", message: "Не удалось установить лайк!", buttonText: "OK", completion: { [weak self] in
            guard let self = self else { return }
            
        })
    }
}
//MARK: - Extensions:
extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        return presenter.fetchNextPhotos(indexPath: indexPath)
    }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else { return CGFloat()}
        return presenter.cellHeight(indexPath: indexPath, tableViewWidth: tableView.bounds.width)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.photosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не удалось создать объект ImagesListCell")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        guard let presenter = presenter else { return UITableViewCell() }
        let isCellConfigured = imageListCell.configCell(
            with: presenter.getThumbURL(indexPath: indexPath),
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
