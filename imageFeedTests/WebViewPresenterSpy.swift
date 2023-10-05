import imageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    // MARK: - Properties:
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    // MARK: - Methods:
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
