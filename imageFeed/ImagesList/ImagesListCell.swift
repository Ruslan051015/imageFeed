import Foundation
import UIKit

public final class ImagesListCell: UITableViewCell {
    //MARK: - Properties:
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    
    //MARK: - IBOutlets:
    @IBOutlet  weak var cellImage: UIImageView!
    @IBOutlet  weak var dateLabel: UILabel!
    @IBOutlet  weak var likeButton: UIButton!
    
    // MARK: - Private properties:
    private let imagesListService = ImagesListService.shared

    // MARK: - LifeCycle:
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        likeButton.accessibilityIdentifier = "LikeButton"
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Methods:
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_pressed") : UIImage(named: "like_not_pressed")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func configCell(with photoURL: String, with indexPath: IndexPath) -> Bool {
        var isConfigured = false
        
        let date = imagesListService.photos[indexPath.row].createdAt
        let placeholder = #imageLiteral(resourceName: "placeholder")
        let imageURL = URL(string: photoURL)
        
        dateLabel.text = DateService.shared.stringFromDate(date: date)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    isConfigured = true
                case .failure:
                    self.cellImage.image = placeholder
                }
            }
        return isConfigured
    }
    
    // MARK: - IBActions:
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
}
