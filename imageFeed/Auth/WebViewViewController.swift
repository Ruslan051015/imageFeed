import Foundation
import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - Properties:
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    // MARK: - Outlets:
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            assertionFailure("Невозможно сформировать url!")
            return
            }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _ , _ in
            guard let self = self else { return }
            self.updateProgress()
        }
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
    // MARK: - Private Methods:
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    // MARK: - Actions:
    @IBAction private func didTapBackButton(_ sender: Any) {
delegate?.webViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {  $0.name == "code"  }) {
            return codeItem.value
        } else {
            return nil
        }
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
