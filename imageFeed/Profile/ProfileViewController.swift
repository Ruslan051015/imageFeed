import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setAvatar(from url: URL)
    func updateProfileDetails(name: String, login: String, status: String)
    func observer()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Properties:
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Private properties:
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    private lazy var logOutButton: UIButton = {
        let logOutImage = UIImage(named: "logOut_logo")
        let button = UIButton(type: .system)
        button.setImage(logOutImage, for: .normal)
        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
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
    
    //MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileScreenConfiguration()
        
        presenter?.addObserverToVC()
        presenter?.configProfileImage()
        presenter?.loadProfileDetails()
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - Methods:
    func observer() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.presenter?.configProfileImage()
            }
    }
    
    func setAvatar(from url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_logo"), options: [
            .processor(processor),
            .transition(.fade(1))])
    }
    
    func updateProfileDetails(name: String, login: String, status: String) {
        profileNameLabel.text = name
        logInLabel.text = login
        statusLabel.text = status
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    //MARK: - Private methods:
    @objc
    private func didTapLogOutButton() {
        showAlert()
    }
    
    private func addToView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    private func turnOfAutoresizing(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func logOutActions() {
        presenter?.exitProfile()
    }
    
    private func showAlert() {
        let alert = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttonText: "Да",
            completion: { [weak self] in
                guard let self = self else { return }
                presenter?.exitProfile()
            },
            secondButtonText: "Нет") { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
        alertPresenter?.show(alert)
    }

    private func profileScreenConfiguration() {
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
