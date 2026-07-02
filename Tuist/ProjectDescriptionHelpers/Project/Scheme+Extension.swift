import ProjectDescription

public extension Scheme {
    static func schemes(name: String, root: Bool = true) -> [Self] {
        guard root else {
            return []
        }

        let targets: [TargetReference] = [.target(name)]

        return [
            .scheme(
                name: name + "_DEV",
                shared: true,
                hidden: false,
                buildAction: .buildAction(targets: targets),
                runAction: .runAction(configuration: .dev),
                archiveAction: .archiveAction(configuration: .dev),
                profileAction: .profileAction(configuration: .dev),
                analyzeAction: .analyzeAction(configuration: .dev)
            ),
            .scheme(
                name: name + "_Stage",
                shared: true,
                hidden: false,
                buildAction: .buildAction(targets: targets),
                runAction: .runAction(configuration: .stage),
                archiveAction: .archiveAction(configuration: .stage),
                profileAction: .profileAction(configuration: .stage),
                analyzeAction: .analyzeAction(configuration: .stage)
            ),
            .scheme(
                name: name + "_Live",
                shared: true,
                hidden: false,
                buildAction: .buildAction(targets: targets),
                runAction: .runAction(configuration: .live),
                archiveAction: .archiveAction(configuration: .live),
                profileAction: .profileAction(configuration: .live),
                analyzeAction: .analyzeAction(configuration: .live)
            ),
        ]
    }

    static func demo(name: String) -> Self {
        .scheme(
            name: name,
            shared: true,
            hidden: false,
            buildAction: .buildAction(targets: [.target(name)]),
            runAction: .runAction(configuration: .dev),
            archiveAction: .archiveAction(configuration: .dev),
            profileAction: .profileAction(configuration: .dev),
            analyzeAction: .analyzeAction(configuration: .dev)
        )
    }
}
