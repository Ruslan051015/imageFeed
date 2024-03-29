import Foundation
import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Properties:
    private let imagesListViewControllerID = "ImagesListViewController"
    private let profileViewControllerID = "ProfileViewController"
    
    // MARK: - Methods:
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: imagesListViewControllerID) as? ImagesListViewController
        guard let imagesListViewController else { return }
        imagesListViewController.presenterConfiguration(ImagesListPresenter())
        
        let profileViewCotroller = ProfileViewController()
        profileViewCotroller.configure(ProfileViewPresenter())
        profileViewCotroller.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewCotroller]
    }
}
