import Foundation
import UIKit
import QuartzCore

final class TranslucentGradient {
    // MARK: - Private properties:
    static let shared = TranslucentGradient()
    var animationLayers = Set<CALayer>()
    // MARK: - Methods:
    func setGradient(view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: view.layer.frame.width, height: view.layer.frame.height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = view.layer.cornerRadius
        gradient.masksToBounds = true
        animationLayers.insert(gradient)
        gradient.add(animateGradient(), forKey: "\(view.tag)")
        
        view.layer.addSublayer(gradient)
    }
    
    func removeGradient() {
        for gradient in animationLayers {
            gradient.removeFromSuperlayer()
        }
    }
    // MARK: - Private methods:
    private func animateGradient() -> CABasicAnimation {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        
        return gradientChangeAnimation
    }
}
