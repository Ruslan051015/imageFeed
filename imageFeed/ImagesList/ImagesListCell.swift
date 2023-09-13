import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - Properties:
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    //MARK: - Outlets:
    @IBOutlet  weak var cellImage: UIImageView!
    @IBOutlet  weak var dateLabel: UILabel!
    @IBOutlet  weak var likeButton: UIButton!
    // MARK: - LifeCycle:
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    // MARK: - Actions:
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    // MARK: - Methods:
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_pressed") : UIImage(named: "like_not_pressed")
        likeButton.setImage(likeImage, for: .normal)
    }
}
