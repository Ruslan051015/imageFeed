import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    //MARK: - Properties:
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var logOutButton: UIButton = {
        let logOutImage = UIImage(named: "logOut_logo")
        let button = UIButton.systemButton(with: logOutImage!, target: self, action: #selector(didTapLogOutButton))
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
    private func updateProfileDetails() {
        profileNameLabel.text = profileService.profile?.name
        logInLabel.text = profileService.profile?.loginName
        statusLabel.text = profileService.profile?.bio
    }
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_logo"), options: [.transition(.fade(1))])
    }
    //MARK: - LifyCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) {
                 [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        updateProfileDetails()
        
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
