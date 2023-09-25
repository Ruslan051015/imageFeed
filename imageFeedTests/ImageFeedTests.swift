@testable import imageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    func testAnimatedUpdateTableViewWasCalled() {
        //given
        let sut = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        sut.presenterConfiguration(presenter)
        
        //when
        let _ = sut.view
        
        //then
        XCTAssertTrue(presenter.imagesListConfigWasCalled)
    }
}
