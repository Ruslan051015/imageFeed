import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: - Properties:
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    // MARK: - Methods:
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .ypBlack
        ProgressHUD.colorAnimation = .lightGray
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
