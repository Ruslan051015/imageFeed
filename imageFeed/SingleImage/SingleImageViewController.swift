import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    //MARK:  Properties:
    var largeURL: URL?
    
    //MARK: - IBOutlets:
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var shareButton: UIButton!
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backwardButton.accessibilityIdentifier = "BackwardButtonOnSIVC"
        
        setImageViewPicture()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
    }
    
    // MARK: - Methods:
    func setImageViewPicture() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                UIBlockingProgressHUD.dismiss()
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    //MARK: - Private methods:
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Что-то пошло не так.\nПопробовать еще раз?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Не надо", style: .default)
        let action2 = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.setImageViewPicture()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
    }
    
    //MARK: - IBActions:
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
}

// MARK: - Extensions:
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
