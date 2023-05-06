import UIKit

class ImagesListViewController: UIViewController {
    //MARK: - Properties:
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    //MARK: - Outlets:
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0 )
    }
    //MARK: - Methods:
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photoName = photosName[indexPath.row]
        cell.cellImage?.image = UIImage(named: photoName)
        cell.dateLabel?.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "Like pressed")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "Like not pressed")
        }
    }
    
    
    
}

