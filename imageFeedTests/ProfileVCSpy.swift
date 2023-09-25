import imageFeed
import Foundation

final class ProfileVCSpy: ProfileViewControllerProtocol {
    var presenter: imageFeed.ProfilePresenterProtocol?
    var updateProfileWasCalled: Bool = false
    func setAvatar(from url: URL) {
        
    }
    
    func updateProfileDetails(name: String, login: String, status: String) {
        updateProfileWasCalled = true
    }
    
    func observer() {
        
    }
    
    
}
