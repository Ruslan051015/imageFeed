import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    //MARK: _ Properties:
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    //MARK: - Outlets:
    @IBOutlet weak var imageView: UIImageView!
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
