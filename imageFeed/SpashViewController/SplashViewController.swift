import Foundation
import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Properties:
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private properties:
    private let showAuthenticationScreenSegue = "AuthenticationScreenSegue"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var wasChecked: Bool = false
    private var alertPresenter: AlertPresenterProtocol?
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
        
        alertPresenter = AlertPresenter(delegate: self)
        
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
}

// MARK: - Private extensions:
private extension SplashViewController {
    func addToView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    func turnOfAutoresizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
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
                self.tokenError()
                break
            }
        }
    }
    
    func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                self.profileImageService.fetchImageURL(username: profile.username) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let imageUrl):
                        print(imageUrl)
                    case .failure(_):
                        self.profileImageError()
                    }
                }
            case .failure:
                self.profileLoginError()
                break
            }
            completion()
        }
    }
    
    func profileImageError() {
        let alert = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалость загрузить фото профиля",
            buttonText: "OK") { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
        alertPresenter?.show(alert)
    }
    
    func profileLoginError() {
        let alert = AlertModel(
            title: "Ошибка",
            message: "Не удалось войти в профиль",
            buttonText: "OK") { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
        alertPresenter?.show(alert)
    }
    
    func tokenError() {
        let alert = AlertModel(
            title: "Ошибка",
            message: "Не удалось получить токен",
            buttonText: "OK") { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
        alertPresenter?.show(alert)
    }
    
    func showAuthController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось создать AuthViewController!")
            return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    func checkAuthStatus() {
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
