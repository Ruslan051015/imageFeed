import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    //MARK: - Properties:
    private let imagesListService = ImagesListService.shared
    private var imageListObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Outlets:
    @IBOutlet private var tableView: UITableView!
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListService.fetchPhotosNextPage()
        imageListObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.DidChangeNotification,
                         object: imagesListService,
                         queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    //MARK: - Methods:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageURL = URL(string: photos[indexPath.row].largeImageURL)
            
            viewController.image = UIImage(named: "placeholder") // Needs to be fixed
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                print(indexPath)
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}
//MARK: - Extensions:
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, photoURL: String, with indexPath: IndexPath) {
        
        let date = imagesListService.photos[indexPath.row].createdAt
        let placeholder = #imageLiteral(resourceName: "placeholder")
        let imageURL = URL(string: photoURL)
        
        cell.dateLabel.text = date?.description
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder) { result in
                switch result {
                case .success:
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure:
                    assertionFailure("Не удалось получить изображение")
                }
            }
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "like_pressed")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "like_not_pressed")
        }
    }
    
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
       let count = photos.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Failed to create object of ImageListCell type")
            return UITableViewCell()
        }
        configCell(for: imageListCell, photoURL: photos[indexPath.row].thumbImageURL, with: indexPath)
        
        return imageListCell
    }
}


