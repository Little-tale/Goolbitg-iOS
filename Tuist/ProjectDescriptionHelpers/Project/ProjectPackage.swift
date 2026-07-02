import ProjectDescription

public var getProjectPackageSetting: [String: Product] {
    projectProductTypes.merging(tcaDynamics) { current, _ in current }
}

private let projectProductTypes: [String: Product] = [
    "Alamofire": .framework,
    "SwiftyBeaver": .framework,
    "KakaoSDKCommon": .framework,
    "KakaoSDKAuth": .framework,
    "KakaoSDKUser": .framework,
    "Lottie": .framework,
    "Kingfisher": .framework,
    "PopupView": .framework,
    "Realm": .staticFramework,
    "RealmSwift": .staticFramework,
]

private let tcaDynamics: [String: Product] = [
    "ComposableArchitecture": .framework,
    "Dependencies": .framework,
    "CombineSchedulers": .framework,
    "Sharing": .framework,
    "CasePathsCore": .framework,
    "SwiftUINavigation": .framework,
    "UIKitNavigation": .framework,
    "UIKitNavigationShim": .framework,
    "ConcurrencyExtras": .framework,
    "Clocks": .framework,
    "CustomDump": .framework,
    "IdentifiedCollections": .framework,
    "XCTestDynamicOverlay": .framework,
    "IssueReporting": .framework,
    "_CollectionsUtilities": .framework,
    "PerceptionCore": .framework,
    "Perception": .framework,
    "OrderedCollections": .framework,
]
