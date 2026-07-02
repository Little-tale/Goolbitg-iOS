public enum FeatureType: String, CaseIterable, Hashable {
    case Common
    case Tab
    case Intro
    case Home
    case Challenge
    case BuyOrNot
    case MyPage

    public static let leadingPathString = "Projects/Modules/Features/"

    public var leadingPath: String {
        Self.leadingPathString
    }
}
