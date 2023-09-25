@testable import imageFeed
import Foundation
import XCTest

final class ProfileTests: XCTest {
    func testProfileVCCallsConfigProfileImage() {
        //given
        var profile = ProfileViewController()
        var presenter = profilePresenterSpy()
        profile.configure(presenter)
        
        //when
        let _ = profile.observer()
        
        //then
        XCTAssertTrue(presenter.configProfileImageWasCalled)
    }
    
    func testLoadProfileDetails() {
        // given
        let sut = ProfileViewPresenter()
        let profile = ProfileVCSpy()
        sut.view = profile
        
        //when
        sut.loadProfileDetails()
        
        //then
        XCTAssertTrue(profile.updateProfileWasCalled)
        
    }
}
