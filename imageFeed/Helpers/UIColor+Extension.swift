import Foundation
import UIKit

extension UIColor {
    static var ypBackground: UIColor { UIColor(named: "YP Background (iOS)") ?? .darkGray }
    static var ypBlack: UIColor { UIColor(named: "YP Black (iOS)") ?? .black }
    static var ypBlue: UIColor { UIColor(named: "YP Blue (iOS)") ?? .blue }
    static var ypGray: UIColor { UIColor(named: "YP Gray (iOS)") ?? .gray }
    static var ypRed: UIColor { UIColor(named: "YP Red (iOS)") ?? .red }
    static var ypWhiteAlpha50: UIColor { UIColor(named: "YP White (Alpha 50%) (iOS)") ?? .white.withAlphaComponent(0.5) }
    static var ypWhite: UIColor { UIColor(named: "YP White (iOS)") ?? .white }
}
