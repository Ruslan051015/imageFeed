import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(view: UIAlertController, animated: Bool)
}
