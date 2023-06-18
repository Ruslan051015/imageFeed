import Foundation
import WebKit

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewControllerDelegate(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        OAuth2Service.shared.fetchOAuthToken(code) { result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage().token = token
                
            case .failure(let error):
                OAuth2TokenStorage().token = ""
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
