import Foundation
import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewControllerDelegate(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewViewController)
}

final class AuthViewController: UIViewController {
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let segueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    private lazy var authImage: UIImageView = {
        var authImage = #imageLiteral(resourceName: "authLogo")
        let image = UIImageView(image: authImage)
        image.bounds.size = CGSize(width: 60, height: 60)
        return image
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypWhite
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - Methods:
    private func addToView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    private func turnOfAutoresizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func buttonTapped() {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError ("Failed to prepare for \(segueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        turnOfAutoresizing(authImage)
        addToView(authImage)
        turnOfAutoresizing(logInButton)
        addToView(logInButton)
        
        NSLayoutConstraint.activate([
            authImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            logInButton.heightAnchor.constraint(equalToConstant: 48),
            logInButton.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewControllerDelegate(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    func webViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
