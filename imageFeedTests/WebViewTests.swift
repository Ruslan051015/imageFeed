
@testable import imageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCalssViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled) // behaviour verification
    }
    
    func testLoadRequest() {
        // given
        let sut = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        sut.presenter = presenter
        presenter.view = sut
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(sut.loadRequestIsCalled)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        let progress: Float = 1
        
        // when
       let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
       var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
        URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        
        //when
        let value = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(value, "test code")
    }
}
