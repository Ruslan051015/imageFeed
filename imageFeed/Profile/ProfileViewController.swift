import UIKit

final class ProfileViewController: UIViewController {
    //MARK: - Properties:
    private var profileImage: UIImageView?
    private var logOutButton: UIButton?
    private var profileNameLabel: UILabel?
    private var logInLabel: UILabel?
    private var statusLabel: UILabel?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Methods:
    @objc
    private func didTapLogOutButton() {
    }
    private func addToView(_ view: UIView) {
        self.view.addSubview(view)
    }
    private func turnOfAutoresizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - LifyCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        let profileImage = #imageLiteral(resourceName: "myPhoto")
        let imageView = UIImageView(image: profileImage)
        turnOfAutoresizing(imageView)
        addToView(imageView)
        self.profileImage = imageView
        
        guard let logOutImage = UIImage(named: "logOut_logo") else { return }
        let logOutButton = UIButton.systemButton(
            with: logOutImage,
            target: self,
            action: #selector(Self.didTapLogOutButton)
        )
        logOutButton.tintColor = .ypRed
        turnOfAutoresizing(logOutButton)
        addToView(logOutButton)
        self.logOutButton = logOutButton
        
        let profileNameLabel = UILabel()
        profileNameLabel.text = "Руслан Халилулин"
        profileNameLabel.textColor = .ypWhite
        profileNameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        turnOfAutoresizing(profileNameLabel)
        addToView(profileNameLabel)
        self.profileNameLabel = profileNameLabel
        
        let logInLabel = UILabel()
        logInLabel.text = "@rusgunner"
        logInLabel.textColor = .ypGray
        logInLabel.font = .systemFont(ofSize: 13)
        turnOfAutoresizing(logInLabel)
        addToView(logInLabel)
        self.logInLabel = logInLabel
        
        let statusLabel = UILabel()
        statusLabel.text = "Hello, World!"
        statusLabel.textColor = .ypWhite
        statusLabel.font = .systemFont(ofSize: 13)
        turnOfAutoresizing(statusLabel)
        addToView(statusLabel)
        self.statusLabel = statusLabel
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            profileNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            profileNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
           
            logInLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            logInLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            logInLabel.heightAnchor.constraint(equalToConstant: 18),
            logInLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            
            statusLabel.leadingAnchor.constraint(equalTo: logInLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 18),
            statusLabel.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 8)
        ])
    }
}
