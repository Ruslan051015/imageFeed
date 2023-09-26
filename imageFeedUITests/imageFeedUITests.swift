import XCTest

final class imageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // Variable of App
    
    override func setUpWithError() throws {
        continueAfterFailure = false // Finishes test if smth went wrong
        
        app.launch() //  Run the app before each test
        
    }
    
    func testAuth() throws {
        // Testing auth script
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["WebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        sleep(1)
        loginTextField.typeText("Ruslan051015@gmail.com")
        app.children(matching: .window).firstMatch.tap()

        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText("Rusikgunner1997")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // Testing feed script
        let tablesQuery = app.tables
       
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        firstCell.swipeUp()
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(5)
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(5)
        
        cellToLike.tap()
        sleep(7)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
        
        let backwardButton = app.buttons["BackwardButtonOnSIVC"]
        backwardButton.tap()
    }
    
    func testProfile() throws {
        // Testing profile script
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["Ruslan Halilulin"].exists)
        XCTAssertTrue(app.staticTexts["@ruslankh97"].exists)
        
        let logOutButton = app.buttons["LogOutButton"]
        logOutButton.tap()
        sleep(2)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
}
