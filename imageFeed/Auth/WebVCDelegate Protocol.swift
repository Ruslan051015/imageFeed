import Foundation
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewControllerDelegate(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewViewController)
}
