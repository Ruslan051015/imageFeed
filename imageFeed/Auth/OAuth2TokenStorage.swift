import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    // MARK: - Properties:
    static let shared = OAuth2TokenStorage()
    private var userDefaults = UserDefaults.standard
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            guard KeychainWrapper.standard.set(newValue ?? "", forKey: Keys.bearerToken.rawValue)
            else {
                assertionFailure("Не удалось сохранить токен")
                return
            }
        }
    }
    // MARK: - Keys for UserDefaults:
    private enum Keys: String, CodingKey {
        case bearerToken
    }
}
