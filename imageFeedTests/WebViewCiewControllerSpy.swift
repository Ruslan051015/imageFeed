import imageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestIsCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestIsCalled = true
        print(loadRequestIsCalled)
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        
    }
    
    func addEstimatedProgressObservation() {
        
    }
    
}
