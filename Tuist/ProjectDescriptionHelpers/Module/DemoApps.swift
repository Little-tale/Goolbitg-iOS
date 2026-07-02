import ProjectDescription

public enum DemoApps: String, CaseIterable, Hashable {
    case home = "Home"
    case challenge = "Challenge"
    case myPage = "MyPage"
    case buyOrNot = "BuyOrNot"
    case intro = "Intro"

    public static let leadingPath = "Projects/Modules/DemoApps"
    public static let moduleLeadingPath = FeatureType.leadingPathString

    public var appName: String {
        "\(rawValue)App"
    }

    public var onlyTargetPath: Path {
        .relativeToRoot("\(Self.leadingPath)/\(appName)")
    }

    public var sourceFilesList: SourceFilesList {
        SourceFilesList.paths([.relativeToRoot("\(Self.moduleLeadingPath)\(rawValue)/Sources/**")])
    }

    public var bundleID: String {
        "\(AppConfig.bundleID)-\(appName)"
    }
}
