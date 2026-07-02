import ProjectDescription

public struct DependencyInfo {
    public let moduleDependencies: [Module: [TargetDependency]]

    public init(moduleDependencies: [Module: [TargetDependency]]) {
        self.moduleDependencies = moduleDependencies
    }
}

public let dependencyInfo = DependencyInfo(
    moduleDependencies: [
        .app: [
            Module.feature(.Tab).projectTarget,
            Module.feature(.Intro).projectTarget,
            Module.feature(.Common).projectTarget,
            Module.utils.projectTarget,
            Module.data.projectTarget,
            .tca,
            .popupView,
            .kakaoSDKCommon,
            .kakaoSDKAuth,
            .swiftyBeaver,
        ],
        .domain: [
            .alamofire,
        ],
        .data: [
            Module.utils.projectTarget,
            .domain,
            .tca,
            .alamofire,
            .swiftyBeaver,
            .realmSwift,
        ],
        .utils: [
            .domain,
            .tca,
            .swiftyBeaver,
            .kingfisher,
            .kakaoSDKCommon,
            .kakaoSDKAuth,
            .kakaoSDKUser,
            .gifu,
            .lottie,
            .fireBaseCrashlytics,
            .firebaseCore,
            .firebaseMessaging,
            .fireBaseAnalytics,
            .imageCompressor,
        ],
        .feature(.Common): [
            Module.utils.projectTarget,
            Module.data.projectTarget,
            .domain,
            .kingfisher,
            .popupView,
        ],
        .feature(.Tab): [
            .tca,
            Module.data.projectTarget,
        ] + Module.tabNeedModules.map(\.projectTarget),
        .feature(.Intro): [
            Module.data.projectTarget,
            Module.utils.projectTarget,
            Module.feature(.Common).projectTarget,
            .tca,
            .kingfisher,
            .popupView,
        ],
        .feature(.Home): [
            Module.feature(.Common).projectTarget,
            .tca,
            .popupView,
        ],
        .feature(.Challenge): featureDetailDependencies,
        .feature(.BuyOrNot): featureDetailDependencies,
        .feature(.MyPage): featureDetailDependencies,
    ]
)

private let featureDetailDependencies: [TargetDependency] = [
    .domain,
    Module.feature(.Common).projectTarget,
    Module.data.projectTarget,
    Module.utils.projectTarget,
    .tca,
    .popupView,
]

public extension Array where Element == TargetDependency {
    static func dependencies(moduleType: Module) -> [TargetDependency] {
        if case .library(let libraryType) = moduleType {
            return [libraryType.targetDependency]
        }

        guard let dependencies = dependencyInfo.moduleDependencies[moduleType] else {
            preconditionFailure("Missing dependency registration for \(moduleType.name)")
        }

        return dependencies
    }
}
