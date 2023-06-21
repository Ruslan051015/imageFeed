import Foundation
import WebKit

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewControllerDelegate(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    func webViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
