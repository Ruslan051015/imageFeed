import Foundation

// MARK: - Unsplash api base paths:
fileprivate let BaseURLString = "https://unsplash.com"
fileprivate let DefaultBaseURL = URL(string: BaseURLString)!
fileprivate let DefaultBaseApiURL = URL(string: "https://api.unsplash.com")!
fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

// MARK: - Unsplash api constants:
fileprivate let AccessKey = "x-rDrCwz6tjpsJ9MAjHX5t3N10O_pq5uaPqos0yQ_Gw"
fileprivate let SecretKey = "OfnLNcNoyVFBsRBhWP3RF_AcrccxDliLtTB_qgiYR3g"
fileprivate let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
fileprivate let AccessScope = "public+read_user+write_likes"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let defaultBaseApiURL: URL
    let authURLString: String
    
    /*static var test: AuthConfiguration {
        return AuthConfiguration(accessKey: <#T##String#>, secretKey: <#T##String#>, redirectURI: <#T##String#>, accessScope: <#T##String#>, defaultBaseURL: <#T##URL#>, authURLString: <#T##String#>)
    }*/
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI, accessScope: AccessScope, defaultBaseURL: DefaultBaseURL, defaultBaseApiURL: DefaultBaseApiURL, authURLString: UnsplashAuthorizeURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, defaultBaseApiURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.defaultBaseApiURL = defaultBaseApiURL
        self.authURLString = authURLString
    }
}
