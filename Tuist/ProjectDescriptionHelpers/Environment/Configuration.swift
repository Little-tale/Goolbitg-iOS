import Foundation
import ProjectDescription

public enum SchemeMode: CaseIterable {
    case dev
    case stage
    case live

    public var schemeName: String {
        switch self {
        case .dev:
            return "Dev"
        case .stage:
            return "Stage"
        case .live:
            return "Live"
        }
    }

    public static func getSelf(schemeString: String) -> SchemeMode? {
        SchemeMode.allCases.first { $0.schemeName == schemeString }
    }

    public var infoPlist: String {
        schemeName + ".Plist"
    }
}

public var getProjectScheme: SchemeMode {
    let schemeString = ProcessInfo.processInfo.environment["TUIST_MODE"] ?? "Dev"
    return SchemeMode.getSelf(schemeString: schemeString) ?? .dev
}

public extension Path {
    static func onesPlistName() -> Path {
        .relativeToRoot("AppSettingFiles/InfoPlist/Info.Plist")
    }

    static func xcconfigPath(_ xcconfigName: String) -> Path {
        .relativeToRoot("AppSettingFiles/XCConfigs/\(xcconfigName).xcconfig")
    }
}

public extension Settings {
    static func appSettings(displayName: String? = nil) -> Self {
        return .settings(
            base: AppConfig.baseSetting(displayName: displayName),
            configurations: .goolbitg,
            defaultSettings: AppConfig.defaultSetting
        )
    }
}

public extension Array where Element == Configuration {
    static let goolbitg: [Configuration] = [
        .debug,
        .release,
        .dev,
        .stage,
        .live,
    ]
}

public extension ConfigurationName {
    static let dev: Self = .configuration(SchemeMode.dev.schemeName)
    static let stage: Self = .configuration(SchemeMode.stage.schemeName)
    static let live: Self = .configuration(SchemeMode.live.schemeName)
}

public extension Configuration {
    static let debug: Self = .debug(name: "Debug", xcconfig: .xcconfigPath("Debug"))
    static let release: Self = .debug(name: "Release", xcconfig: .xcconfigPath("Release"))
    static let dev: Self = .debug(name: .dev, xcconfig: .xcconfigPath(SchemeMode.dev.schemeName))
    static let stage: Self = .debug(name: .stage, xcconfig: .xcconfigPath(SchemeMode.stage.schemeName))
    static let live: Self = .release(name: .live, xcconfig: .xcconfigPath(SchemeMode.live.schemeName))
}
