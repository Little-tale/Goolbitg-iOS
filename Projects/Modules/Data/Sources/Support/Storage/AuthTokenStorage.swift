//
//  AuthTokenStorage.swift
//  Data
//
//  Created by Jae hyung Kim on 1/9/26.
//

import Foundation

@propertyWrapper
public struct AuthTokenStorageWrapper {
    public let key: String
    public let placeValue: String
    public let sync: KeychainSync
    
    /// - Parameters:
    ///   - key: Keychain account
    ///   - placeValue: 값이 없을 때 반환할 placeholder(기본값)
    ///   - sync: iCloud 동기화 여부(기본 localOnly)
    public init(key: String, placeValue: String = "", sync: KeychainSync = .localOnly) {
        self.key = key
        self.placeValue = placeValue
        self.sync = sync
    }
    
    public var wrappedValue: String? {
        get {
            do {
                let value = try KeyChainManager.readString(for: key, sync: sync)
                return value
            } catch {
                print("Error = \(error.localizedDescription)")
                return nil
            }
        }
        set {
            do {
                if let newValue {
                    // 값 설정 → 저장
                    try KeyChainManager.save(value: newValue, for: key, isForce: false, sync: sync)
                } else {
                    // nil 설정 → 삭제
                    try KeyChainManager.delete(for: key, sync: sync)
                }
            } catch {
                print("Error = \(error.localizedDescription)")
            }
        }
    }
    
    public var projectedValue: Self { self }
    
    public func remove() {
        try? KeyChainManager.delete(for: key, sync: sync)
    }
}

public struct AuthTokenStorage {
    
    private enum AuthTokenStorageKey: String {
        case accessToken
        case refreshToken
        
        fileprivate var key: String {
            return "auth." + self.rawValue
        }
    }
    
    public static var accessToken: String? {
        get { value(for: .accessToken) }
        set { setValue(newValue, for: .accessToken) }
    }

    public static var refreshToken: String? {
        get { value(for: .refreshToken) }
        set { setValue(newValue, for: .refreshToken) }
    }

    public init() {}

    public static func clearAll() {
        remove(.accessToken)
        remove(.refreshToken)
    }
}

private extension AuthTokenStorage {
    private static func value(for key: AuthTokenStorageKey) -> String? {
        do {
            return try KeyChainManager.readString(for: key.key)
        } catch {
            print("Error = \(error.localizedDescription)")
            return nil
        }
    }

    private static func setValue(_ newValue: String?, for key: AuthTokenStorageKey) {
        do {
            if let newValue {
                try KeyChainManager.save(value: newValue, for: key.key)
            } else {
                try KeyChainManager.delete(for: key.key)
            }
        } catch {
            print("Error = \(error.localizedDescription)")
        }
    }

    private static func remove(_ key: AuthTokenStorageKey) {
        try? KeyChainManager.delete(for: key.key)
    }
}
