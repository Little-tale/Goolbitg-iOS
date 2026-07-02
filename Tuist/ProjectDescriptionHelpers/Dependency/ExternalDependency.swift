import ProjectDescription

public enum DomainConfig {
    public static let frameworkName = "Domain"
    public static let path: Path = .relativeToRoot("Projects/Domain")
    public static let target: TargetDependency = .project(
        target: frameworkName,
        path: path
    )
}

public extension TargetDependency {
    static let domain: Self = DomainConfig.target
    static let swiftyBeaver: Self = Module.library(.SwiftyBeaver).projectTarget
    static let tca: Self = Module.library(.ComposableArchitecture).projectTarget
    static let firebaseCore: Self = Module.library(.FirebaseCore).projectTarget
    static let firebaseMessaging: Self = Module.library(.FirebaseMessaging).projectTarget
    static let fireBaseAnalytics: Self = Module.library(.FirebaseAnalytics).projectTarget
    static let fireBaseCrashlytics: Self = Module.library(.FirebaseCrashlytics).projectTarget
    static let kakaoSDKCommon: Self = Module.library(.KakaoSDKCommon).projectTarget
    static let kakaoSDKAuth: Self = Module.library(.KakaoSDKAuth).projectTarget
    static let kakaoSDKUser: Self = Module.library(.KakaoSDKUser).projectTarget
    static let kakaoSDK: Self = Module.library(.KakaoSDK).projectTarget
    static let kingfisher: Self = Module.library(.Kingfisher).projectTarget
    static let alamofire: Self = Module.library(.Alamofire).projectTarget
    static let socketIO: Self = Module.library(.SocketIO).projectTarget
    static let realmSwift: Self = Module.library(.RealmSwift).projectTarget
    static let realm: Self = Module.library(.Realm).projectTarget
    static let popupView: Self = Module.library(.PopupView).projectTarget
    static let lottie: Self = Module.library(.Lottie).projectTarget
    static let imageCompressor: Self = Module.library(.SwiftImageCompressor).projectTarget
    static let gifu: Self = Module.library(.Gifu).projectTarget
}
