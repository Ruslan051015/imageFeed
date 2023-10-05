import imageFeed
import Foundation

final class profilePresenterSpy: ProfilePresenterProtocol {
    var view: imageFeed.ProfileViewControllerProtocol?
    var configProfileImageWasCalled: Bool = false
    
    func configProfileImage() {
        configProfileImageWasCalled = true
    }
    
    func loadProfileDetails() {
        
    }
    
    func showSplashVC() {
        
    }
    
    func cleanKfCache() {
        
    }
    
    func cleanCoockiesFromWV() {
        
    }
    
    func deleteToken() {
        
    }
    
    func addObserverToVC() {
        
    }
    
    func exitProfile() {
        
    }
    
    
}

