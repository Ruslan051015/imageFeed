import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: - Private properties:
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    // MARK: - Methods:
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.colorStatus = .ypBlack
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
