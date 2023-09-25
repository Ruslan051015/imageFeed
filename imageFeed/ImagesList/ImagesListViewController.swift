import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func addingObserver()
    func showLikeError()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    //MARK: - Properties:
    var presenter: ImagesListPresenterProtocol?
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
        presenter?.animatedUpdateTableView()
    }
    
    func showLikeError() {
        let alert = AlertModel(title: "Ошибка", message: "Не удалось установить лайк!", buttonText: "OK", completion: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })
        alertPresenter?.show(alert)
    }
    
    func presenterConfiguration(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
}
//MARK: - Extensions:
extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        presenter.fetchNextPhotos(indexPath: indexPath)
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
        
        guard
            let presenter = presenter,
            let photo = presenter.getPhoto(indexPath: indexPath) else {
            return UITableViewCell()
        }
        let isCellConfigured = imageListCell.configCell(
            with: photo.thumbImageURL,
            with: indexPath)
        imageListCell.setIsLiked(isLiked: photo.isLiked)
        if isCellConfigured {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return imageListCell
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        UIBlockingProgressHUD.show()
        guard let presenter = presenter else { return }
        presenter.settingLike(for: cell, indexPath: indexPath)
        
    }
}


