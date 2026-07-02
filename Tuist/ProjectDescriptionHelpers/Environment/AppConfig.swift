import ProjectDescription

public enum AppConfig {
    public static let appName = "Goolbitg-iOS"
    public static let productName = "굴비잇기"
    public static let bundleID = "com.Goolbitg-iOS"
    public static let deployTarget: DeploymentTargets = .iOS("16.0")
    public static let destinations: Destinations = [.iPhone]
    public static let appPath: Path = .relativeToRoot("Projects/App")
    public static let baseSetting: SettingsDictionary = [
        "OTHER_LDFLAGS": ["$(inherited) -Objc"],
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "OTHER_SWIFT_FLAGS": ["$(inherited)", "-enable-actor-data-race-checks"],
        "ENABLE_TESTABILITY": "YES",
        "SWIFT_VERSION" : "5.9"
    ]
    public static let defaultSetting = DefaultSettings.recommended(excluding: [
        "SWIFT_ACTIVE_COMPILATION_CONDITIONS"
    ])

    public static func baseSetting(displayName: String? = nil) -> SettingsDictionary {
        var base = baseSetting

        if let displayName {
            base["DISPLAY_NAME"] = .string(displayName)
        }

        return base
    }
}
