@testable import imageFeed
import Foundation
import XCTest

final class ProfileTests: XCTestCase {
    func testconfigProfileImage() {
        //given
        let profile = ProfileViewController()
        let presenter = profilePresenterSpy()
        profile.configure(presenter)
        
        //when
        let _ = profile.view
        
        //then
        XCTAssertTrue(presenter.configProfileImageWasCalled)
    }
}
