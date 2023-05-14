import UIKit

final class ProfileViewController: UIViewController {
  //MARK: - Properties:
    override  var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Outlets:
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    //MARK: - Actions:
    @IBAction func logOutAction(_ sender: Any) {
    }
    //MARK: - LifyCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
