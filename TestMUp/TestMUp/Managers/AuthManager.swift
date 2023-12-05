//
//  AuthManager.swift
//  TestMUp
//
//  Created by Нахид Гаджалиев on 28.04.2023.
//

import Foundation

final class AuthManager {
    private enum Constants {
        static let url = URL(string: "https://oauth.vk.com/authorize?client_id=\(R.string.constants.appId())&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=photos&revoke=1&response_type=token&v=5.131")
    }
    let defaults = UserDefaults.standard
    static let shared = AuthManager()
    
    var loginURL: URL? {
        return Constants.url
    }
    
    var token: String? {
        return defaults.string(forKey: R.string.constants.keyAccessToken())
    }
    
    var tokenExpDate: Date? {
        return defaults.object(forKey: R.string.constants.keyExpirationDate()) as? Date
    }
    
    var isTokenExpired: Bool {
        guard let expDate = tokenExpDate else { return false }
        let curDate = Date()
        return curDate >= expDate
    }
    
    var isUserLoggedIn: Bool {
        return token != nil
    }
}

// MARK: - Methods
extension AuthManager {
    func authorization(redirectString: String, completion: @escaping (Bool) -> Void) {
        let redirectStringArray = redirectString.components(separatedBy: String.grid)
        let data = redirectStringArray[Int.one]
        let dataArray = data.components(separatedBy: String.ampersand)
        var token: String?
        var expirationDate: Int?
        
        dataArray.forEach { value in
            let valuePair = value.components(separatedBy: String.equals)
            
            switch valuePair[Int.zero] {
            case R.string.constants.keyAccessToken():
                token = valuePair[Int.one]
            case R.string.constants.expiresIn():
                expirationDate = Int(valuePair[Int.one])
            default:
                print(valuePair)
            }
        }
        
        guard let token = token, let expDate = expirationDate else {
            completion(false)
            return
        }
        saveToken(with: token, and: expDate)
        completion(true)
    }
    
    func logOut(completion: @escaping (Bool) -> Void) {
        defaults.set(nil, forKey: R.string.constants.keyAccessToken())
        defaults.setValue(nil, forKey: R.string.constants.keyExpirationDate())
        completion(true)
    }
    
    private func saveToken(with token: String, and expires_in: Int) {
        defaults.setValue(token, forKey: R.string.constants.keyAccessToken())
        defaults.setValue(
            Date().addingTimeInterval(TimeInterval(expires_in)),
            forKey: R.string.constants.keyExpirationDate()
        )
    }
}
