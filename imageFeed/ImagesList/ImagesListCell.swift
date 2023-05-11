import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - Properties:
    static let reuseIdentifier = "ImagesListCell"
    //MARK: - Outlets:
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
}
