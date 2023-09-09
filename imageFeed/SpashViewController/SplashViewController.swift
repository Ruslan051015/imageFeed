import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class SplashViewController: UIViewController {
    // MARK: - Properties:
    private let showAuthenticationScreenSegue = "AuthenticationScreenSegue"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var wasChecked: Bool = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let screenLogo: UIImageView = {
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "Vector")
        return imageview
    }()
    // MARK: - LifeCycle:
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnOfAutoresizing(screenLogo)
        addToView(screenLogo)
        view.backgroundColor = .ypBlack
        NSLayoutConstraint.activate([
            screenLogo.widthAnchor.constraint(equalToConstant: 75),
            screenLogo.heightAnchor.constraint(equalToConstant: 78),
            screenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            screenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    // MARK: - Private Methods:
    private func addToView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    private func turnOfAutoresizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    private func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile() { [weak self] result in
            switch result {
            case .success(let profile):
                self?.switchToTabBarController()
                self?.profileImageService.fetchImageURL(username: profile.username) { [weak self] result in
                    switch result {
                    case .success(let imageUrl):
                        print(imageUrl)
                    case .failure(_):
                        self?.showAlert(title: "Что-то пошло не так", message: "Не удалость загрузить фото профиля")
                    }
                }
            case .failure:
                self?.showAlert(title: "Ошибка", message: "Не удалось войти в профиль!")
                break
            }
            completion()
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    private func showAuthController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось создать AuthViewController!")
            return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    private func checkAuthStatus() {
        guard !wasChecked else { return }
        
        wasChecked = true
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            
            fetchProfile { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            showAuthController()
        }
    }
}
// MARK: - Extensions
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.fetchProfile {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self.showAlert(title: "Ошибка", message: "Не удалось получить токен")
                break
            }
        }
    }
}
