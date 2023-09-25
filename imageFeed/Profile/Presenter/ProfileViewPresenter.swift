import Foundation
import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func configProfileImage()
    func loadProfileDetails()
    func showSplashVC()
    func cleanKfCache()
    func cleanCoockiesFromWV()
    func deleteToken()
    func addObserverToVC()
    func exitProfile()
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    // MARK: - Properties:
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private properties:
    private let profileService = ProfileService.shared
    private let token = OAuth2TokenStorage.shared
    
    // MARK: - Methods:
    func showSplashVC() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    func configProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(from: url)
    }
    
    func loadProfileDetails() {
        guard let profile = profileService.profile else {
            assertionFailure("Сохраненные данные профиля отсутствуют")
            return }
        let profileName = profile.name
        let loginName = profile.loginName
        let statusText = profile.bio ?? ""
        
        view?.updateProfileDetails(name: profileName, login: loginName, status: statusText)
    }
    
    func cleanKfCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    func cleanCoockiesFromWV() {
        WebViewViewController.cleanCookies()
    }
    
    func deleteToken() {
        token.deleteToken()
    }
    
    func exitProfile() {
        cleanKfCache()
        cleanCoockiesFromWV()
        deleteToken()
    }
    
    func addObserverToVC() {
        view?.observer()
    }
}
