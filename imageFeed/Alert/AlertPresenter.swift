import Foundation
import UIKit

final class AlertPresenter {
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func show(_ model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        if let secondButton = model.secondButtonText {
            let secondAction = UIAlertAction(title: model.secondButtonText, style: .default) { _ in
                model.secondCompletion()
            }
            alert.addAction(secondAction)
        }
        delegate?.present(view: alert, animated: true)
    }
}
