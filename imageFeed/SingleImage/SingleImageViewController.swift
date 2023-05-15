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
    @IBOutlet weak var backwardButton: UIButton!
    //MARK: - Actions:
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
