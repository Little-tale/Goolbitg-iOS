import ProjectDescription

private let appEntitlementsPath: Entitlements = .file(
    path: .relativeToRoot("AppSettingFiles/Entitlements/Goolbitg-iOS.entitlements")
)

public extension Project {
    static func module(moduleType: Module, hasDemo: Bool = false) -> Project {
        Project(
            name: moduleType.name,
            packages: [],
            settings: .appSettings(),
            targets: moduleType.targets(hasDemo: hasDemo),
            schemes: moduleType.schemes(hasDemo: hasDemo),
            resourceSynthesizers: moduleType.resourceSynthesizers
        )
    }

    static func demoApp(_ demoApp: DemoApps) -> Project {
        Project(
            name: demoApp.appName,
            packages: [],
            settings: .appSettings(displayName: demoApp.appName),
            targets: [.demoApp(demoApp)],
            schemes: Scheme.schemes(name: demoApp.appName),
            resourceSynthesizers: [
                .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
                .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
            ]
        )
    }
}

private extension Module {
    func targets(hasDemo: Bool) -> [Target] {
        if case .library = self {
            preconditionFailure("External libraries cannot generate Tuist projects: \(name)")
        }

        var targets = [Target.target(moduleType: self)] + customTargets

        if hasDemo {
            targets.append(.demo(moduleType: self))
        }

        return targets
    }

    var product: Product {
        switch self {
        case .app:
            return .app
        case .domain, .feature, .data, .utils:
            return .framework
        case .library:
            preconditionFailure("External libraries do not have a product: \(name)")
        }
    }

    var bundleID: String {
        switch self {
        case .app:
            return "$(PRODUCT_BUNDLE_IDENTIFIER)"
        case .domain, .feature, .data, .utils:
            return "com.frameWork.\(name)"
        case .library:
            preconditionFailure("External libraries do not have a bundle id: \(name)")
        }
    }

    var bundlePrefix: String {
        AppConfig.bundleID
    }

    var infoPlist: InfoPlist {
        switch self {
        case .app:
            return .file(path: Path.onesPlistName())
        case .domain, .feature, .data, .utils:
            return .default
        case .library:
            preconditionFailure("External libraries do not have an Info.plist: \(name)")
        }
    }

    var hasResources: Bool {
        switch self {
        case .app, .feature(.Intro), .utils:
            return true
        case .domain, .feature, .data:
            return false
        case .library:
            preconditionFailure("External libraries do not have resources: \(name)")
        }
    }

    var resources: ResourceFileElements? {
        switch self {
        case .app:
            return [
                .glob(
                    pattern: .relativeToRoot("AppSettingFiles/AppResources/**"),
                    excluding: [],
                    tags: [],
                    inclusionCondition: nil
                ),
            ]
        case .feature(.Intro), .utils:
            return ["Resources/**"]
        case .domain, .feature, .data:
            return nil
        case .library:
            preconditionFailure("External libraries do not have resources: \(name)")
        }
    }

    var entitlements: Entitlements? {
        switch self {
        case .app:
            return appEntitlementsPath
        case .domain, .feature, .data, .utils:
            return nil
        case .library:
            preconditionFailure("External libraries do not have entitlements: \(name)")
        }
    }

    var scripts: [TargetScript] {
        switch self {
        case .app:
            return [
                .fireBase,
                .fireBaseCrashlyticsRun,
            ]
        case .domain, .feature, .data, .utils:
            return []
        case .library:
            preconditionFailure("External libraries do not have scripts: \(name)")
        }
    }

    var schemes: [Scheme] {
        schemes(hasDemo: false)
    }

    func schemes(hasDemo: Bool) -> [Scheme] {
        switch self {
        case .app:
            return Scheme.schemes(name: name, root: true)
        case .feature where hasDemo:
            return [.demo(name: "\(name)Demo")]
        case .domain, .feature, .data, .utils:
            return []
        case .library:
            preconditionFailure("External libraries do not have schemes: \(name)")
        }
    }

    var resourceSynthesizers: [ResourceSynthesizer] {
        [
            .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
            .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
        ]
    }

    var customTargets: [Target] {
        switch self {
        case .data:
            return [.unitTestTarget(name: "DataTests", targetName: name)]
        case .feature(.Common):
            return [.unitTestTarget(name: "FeatureCommonTests", targetName: name)]
        case .feature(.Tab):
            return [.unitTestTarget(name: "FeatureTabTests", targetName: name)]
        case .app, .domain, .feature, .utils:
            return []
        case .library:
            preconditionFailure("External libraries cannot generate custom targets: \(name)")
        }
    }
}

public extension Target {
    static func target(moduleType: Module) -> Target {
        .implements(
            name: moduleType.name,
            product: moduleType.product,
            bundleID: moduleType.bundleID,
            infoPlist: moduleType.infoPlist,
            sources: .default,
            resources: moduleType.resources,
            entitlements: moduleType.entitlements,
            scripts: moduleType.scripts,
            dependencies: .dependencies(moduleType: moduleType)
        )
    }

    static func demo(moduleType: Module) -> Target {
        let demoName = "\(moduleType.name)Demo"
        let bundleID = "\(moduleType.bundlePrefix)-demo-\(demoName)"

        return .target(
            name: demoName,
            destinations: AppConfig.destinations,
            product: .app,
            bundleId: bundleID,
            deploymentTargets: AppConfig.deployTarget,
            infoPlist: .file(path: "Demo/Support/Info.plist"),
            sources: .demo,
            dependencies: moduleType.demoDependencies,
            settings: .settings(
                base: AppConfig.baseSetting.merging(["BUNDLE_NAME": .string(demoName)]) { _, new in new },
                configurations: .goolbitg,
                defaultSettings: AppConfig.defaultSetting
            )
        )
    }

    static func demoApp(_ demoApp: DemoApps) -> Target {
        .implements(
            name: demoApp.appName,
            product: .app,
            bundleID: demoApp.bundleID,
            infoPlist: .file(path: Path.onesPlistName()),
            sources: demoApp.sourceFilesList,
            resources: [
                .glob(
                    pattern: .relativeToRoot("AppSettingFiles/AppResources/**"),
                    excluding: [],
                    tags: [],
                    inclusionCondition: nil
                ),
            ],
            entitlements: appEntitlementsPath,
            scripts: [
                .fireBase,
                .fireBaseCrashlyticsRun,
            ],
            dependencies: demoApp.dependencies,
            displayName: demoApp.appName
        )
    }

    static func unitTestTarget(name: String, targetName: String) -> Target {
        .target(
            name: name,
            destinations: AppConfig.destinations,
            product: .unitTests,
            bundleId: "com.frameWork.\(name)",
            deploymentTargets: AppConfig.deployTarget,
            sources: .tests,
            dependencies: [
                .target(name: targetName),
            ],
            settings: .settings(
                base: AppConfig.baseSetting,
                configurations: .goolbitg,
                defaultSettings: AppConfig.defaultSetting
            )
        )
    }
}

private extension Target {
    static func implements(
        name: String,
        product: Product,
        bundleID: String,
        infoPlist: InfoPlist,
        sources: SourceFilesList?,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency],
        displayName: String? = nil
    ) -> Target {
        Target.target(
            name: name,
            destinations: AppConfig.destinations,
            product: product,
            bundleId: bundleID,
            deploymentTargets: AppConfig.deployTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: .settings(
                base: AppConfig.baseSetting(displayName: displayName),
                configurations: .goolbitg,
                defaultSettings: AppConfig.defaultSetting
            )
        )
    }
}

private extension Module {
    var demoDependencies: [TargetDependency] {
        [.target(name: name)]
    }
}

private extension DemoApps {
    var dependencies: [TargetDependency] {
        let commonDependencies: [TargetDependency] = [
            Module.feature(.Common).projectTarget,
            Module.utils.projectTarget,
            Module.data.projectTarget,
            .domain,
            .tca,
        ]

        switch self {
        case .home:
            return commonDependencies + [
                .swiftyBeaver,
            ]

        case .challenge, .buyOrNot:
            return commonDependencies + [
                .popupView,
            ]

        case .intro:
            return commonDependencies + [
                .kingfisher,
                .popupView,
            ]

        case .myPage:
            return commonDependencies + [
                .lottie,
                .popupView,
            ]
        }
    }
}

private extension SourceFilesList? {
    static var `default`: SourceFilesList? { ["Sources/**"] }
    static var demo: SourceFilesList? { ["Demo/Sources/**"] }
    static var tests: SourceFilesList? { ["Tests/**"] }
}
