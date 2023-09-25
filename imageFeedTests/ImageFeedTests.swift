@testable import imageFeed
import XCTest

final class ImageFeedTests: XCTest {
    func testAnimatedUpdateTableViewWasCalled() {
        //given
        let sut = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        sut.presenterConfiguration(presenter)
        
        //when
        sut.addingObserver()
        
        //then
        XCTAssertTrue(presenter.animatedUpdateTableViewWasCalled)
    }
}
