import Foundation
import UIKit
import WebKit

final class AuthViewController: UIViewController {
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let segueIdentifier = "ShowWebView"
    private lazy var authImage: UIImageView = {
        var authImage = #imageLiteral(resourceName: "authLogo")
        let image = UIImageView(image: authImage)
        image.bounds.size = CGSize(width: 60, height: 60)
        return image
    }()
    private lazy var button: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.backgroundColor = .ypWhite
        logInButton.setTitle("Войти", for: .normal)
        logInButton.setTitleColor(.ypBlack, for: .normal)
        logInButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        logInButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        logInButton.layer.cornerRadius = 16
        logInButton.layer.masksToBounds = true
        return logInButton
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
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError ("Failed to prepare for \(segueIdentifier)") }
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
        turnOfAutoresizing(button)
        addToView(button)
        
        NSLayoutConstraint.activate([
            authImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
}
