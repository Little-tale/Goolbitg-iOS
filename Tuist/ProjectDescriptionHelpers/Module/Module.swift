import ProjectDescription

public enum Module: Hashable {
    case app
    case domain
    case data
    case utils
    case feature(FeatureType)
    case library(LibraryType)

    public var name: String {
        switch self {
        case .app:
            return AppConfig.appName
        case .domain:
            return "Domain"
        case .feature(let featureType):
            return "Feature\(featureType.rawValue)"
        case .data:
            return "Data"
        case .utils:
            return "Utils"
        case .library(let libraryType):
            return libraryType.name
        }
    }

    public var frameWorkName: String {
        name
    }

    public var path: Path {
        switch self {
        case .app:
            return AppConfig.appPath
        case .domain:
            return "Projects/\(name)"
        case .feature(let featureType):
            return .relativeToRoot("\(featureType.leadingPath)\(featureType.rawValue)")
        case .data, .utils:
            return .relativeToRoot("Projects/Modules/\(name)")
        case .library:
            preconditionFailure("External libraries do not have a project path: \(name)")
        }
    }

    public var projectTarget: TargetDependency {
        if case .library(let libraryType) = self {
            return libraryType.targetDependency
        }

        return .project(target: name, path: path)
    }

    public static var features: [Module] {
        FeatureType.allCases.map { .feature($0) }
    }

    public static var modules: [Module] {
        features + [.data, .utils]
    }

    public static var tabNeedModules: [Module] {
        FeatureType.allCases
            .filter { $0 != .Intro && $0 != .Tab }
            .map { .feature($0) }
    }
}

public enum LibraryType: String, CaseIterable, Hashable {
    case ComposableArchitecture
    case Alamofire
    case SwiftyBeaver
    case FirebaseCore
    case FirebaseMessaging
    case FirebaseAnalytics
    case FirebaseCrashlytics
    case KakaoSDKCommon
    case KakaoSDKAuth
    case KakaoSDKUser
    case KakaoSDK
    case Kingfisher
    case SocketIO
    case RealmSwift
    case Realm
    case PopupView
    case Lottie
    case SwiftImageCompressor
    case Gifu

    public var name: String {
        rawValue
    }

    public var targetDependency: TargetDependency {
        .external(name: name, condition: nil)
    }
}
