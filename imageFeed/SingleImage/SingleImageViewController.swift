import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    //MARK:  Properties:
    var largeURL: URL?

    //MARK: - Outlets:
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var shareButton: UIButton!
    //MARK: - Actions:
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    //MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
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
                fatalError("Нет изображения")
            }
            
        }
    }
    
    //MARK: - Private Methods:
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
}
// MARK: Extensions:
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
