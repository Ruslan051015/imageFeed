import Foundation
import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHiden(_ isHidden: Bool)
    func addEstimatedProgressObservation()
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    // MARK: - Properties:
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    
    // MARK: - Private properties:
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.accessibilityIdentifier = "WebView"
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    // MARK: - Methods:
    static func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func addEstimatedProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] _ , _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    // MARK: - IBActions:
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewControllerDidCancel(self)
    }
}

// MARK: - Extensions:
extension WebViewViewController: WKNavigationDelegate {
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewControllerDelegate(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
