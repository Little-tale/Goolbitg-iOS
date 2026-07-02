//
//  UserDefaultActor.swift
//  Utils
//
//  Created by Jae hyung Kim on 5/21/25.
//

import Foundation

public enum UserDefaultsManager {
    
    public enum Key: String {
        case deviceToken
        
        case accessToken
        case refreshToken
        case userNickname
        case userID
        case userHabitType
        
        /// 디바이스 기준 처음 인지
        case firstDevice
        case appleLoginAccess
        case appleLoginRefresh
        
        /// 루트 로그인 유저인지
        case rootLoginUser
        
        /// 애플 로그인 유저인지 구분합니다.
        case ifAppleLoginUser
        
        /// FCM  registrationToken
        case fcmRegistrationToken
        case fcmReciveCount
        
        var value: String {
            return self.rawValue
        }
    }
    
    public static var deviceToken: String {
        get { value(for: .deviceToken, placeValue: "") }
        set { setValue(newValue, for: .deviceToken, placeValue: "") }
    }
    
    @available(*, deprecated, renamed: "KeyChainManager", message: "use KeyChainManager")
    public static var accessToken: String {
        get { value(for: .accessToken, placeValue: "") }
        set { setValue(newValue, for: .accessToken, placeValue: "") }
    }
    
    @available(*, deprecated, renamed: "KeyChainManager", message: "use KeyChainManager")
    public static var refreshToken: String {
        get { value(for: .refreshToken, placeValue: "") }
        set { setValue(newValue, for: .refreshToken, placeValue: "") }
    }
    
    public static var firstDevice: Bool {
        get { value(for: .firstDevice, placeValue: true) }
        set { setValue(newValue, for: .firstDevice, placeValue: true) }
    }
    
    public static var userNickname: String {
        get { value(for: .userNickname, placeValue: "") }
        set { setValue(newValue, for: .userNickname, placeValue: "") }
    }
    
    public static var userID: String {
        get { value(for: .userID, placeValue: "") }
        set { setValue(newValue, for: .userID, placeValue: "") }
    }
    
    public static var userHabitType: Int? {
        get { value(for: .userHabitType, placeValue: nil) }
        set { setValue(newValue, for: .userHabitType, placeValue: nil) }
    }
    
    public static var appleAccessToken: String? {
        get { value(for: .appleLoginAccess, placeValue: nil) }
        set { setValue(newValue, for: .appleLoginAccess, placeValue: nil) }
    }
    
    public static var appleRefreshToken: String? {
        get { value(for: .appleLoginRefresh, placeValue: nil) }
        set { setValue(newValue, for: .appleLoginRefresh, placeValue: nil) }
    }
    
    public static var ifAppleLoginUser: Bool {
        get { value(for: .ifAppleLoginUser, placeValue: false) }
        set { setValue(newValue, for: .ifAppleLoginUser, placeValue: false) }
    }
    
    public static var fcmRegistrationToken: String? {
        get { value(for: .fcmRegistrationToken, placeValue: nil) }
        set { setValue(newValue, for: .fcmRegistrationToken, placeValue: nil) }
    }
    
    public static var fcmReciveCount: Int {
        get { value(for: .fcmReciveCount, placeValue: 0) }
        set { setValue(newValue, for: .fcmReciveCount, placeValue: 0) }
    }
    
    public static var rootLoginUser: Bool {
        get { value(for: .rootLoginUser, placeValue: false) }
        set { setValue(newValue, for: .rootLoginUser, placeValue: false) }
    }
}

private extension UserDefaultsManager {
    static func value<T: Codable>(for key: Key, placeValue: T) -> T {
        UserDefaultsWrapper(key: key.value, placeValue: placeValue).wrappedValue
    }

    static func setValue<T: Codable>(_ newValue: T, for key: Key, placeValue: T) {
        var wrapper = UserDefaultsWrapper(key: key.value, placeValue: placeValue)
        wrapper.wrappedValue = newValue
    }
}

extension UserDefaultsManager {
    
    public static func resetUser() {
        UserDefaultsManager.userNickname = ""
//        UserDefaultsManager.accessToken = ""
//        UserDefaultsManager.refreshToken = ""
        AuthTokenStorage.clearAll()
        UserDefaultsManager.ifAppleLoginUser = false
    }
}

@propertyWrapper
public struct UserDefaultsWrapper<T: Codable> {
    public let key: String
    public let placeValue: T
    
    private let userDefaults = UserDefaults.standard
    
    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key),
                  let value = try? CodableManager.shared.jsonDecoding(model: T.self, from: data) else {
                return placeValue
            }
            return value
        } set {
            guard let data = try? CodableManager.shared.jsonEncoding(from: newValue)
            else {
                return
            }
            userDefaults.setValue(data, forKey: key)
        }
    }
}
