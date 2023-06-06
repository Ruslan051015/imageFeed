import UIKit

final class ProfileViewController: UIViewController {
    //MARK: - Properties:
    private lazy var profileImage: UIImageView = {
        var profileImage = #imageLiteral(resourceName: "myPhoto")
        let imageView = UIImageView(image: profileImage)
        
        return imageView
    }()
    private lazy var logOutButton: UIButton = {
        let logOutImage = UIImage(named: "logOut_logo")
        let button = UIButton.systemButton(with: logOutImage!, target: self, action: #selector(didTapLogOutButton))
        //        let button = UIButton(type: .system)
        //        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        button.imageView?.image = logOutImage
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var profileNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Руслан Халилулин"
        nameLabel.textColor = .ypWhite
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        return nameLabel
    }()
    private lazy var logInLabel: UILabel = {
        let label = UILabel()
        label.text = "@rusgunner"
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    private lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.text = "Hello, World!"
        status.textColor = .ypWhite
        status.font = .systemFont(ofSize: 13)
        
        return status
    }()
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
        
        turnOfAutoresizing(profileImage)
        addToView(profileImage)
        
        turnOfAutoresizing(logOutButton)
        addToView(logOutButton)
        
        turnOfAutoresizing(profileNameLabel)
        addToView(profileNameLabel)
        
        turnOfAutoresizing(logInLabel)
        addToView(logInLabel)
        
        turnOfAutoresizing(statusLabel)
        addToView(statusLabel)
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            profileNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            profileNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            
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
