import ProjectDescription

private let moduleNameAttribute = Template.Attribute.required("name")
private let hasDemoAttribute = Template.Attribute.optional("hasDemo", default: "false")
private let path = "Projects/Modules/Features/\(moduleNameAttribute)"

private let template = Template(
    description: "A template for goolbitg feature modules.",
    attributes: [
        moduleNameAttribute,
        hasDemoAttribute,
    ],
    items: [
        .file(
            path: "\(path)/Project.swift",
            templatePath: "Sources/Project.swift.stencil"
        ),
        .file(
            path: "\(path)/Sources/DefaultSourceCode.swift",
            templatePath: "Sources/DefaultSourceCode.swift.stencil"
        ),
        .file(
            path: "\(path)/Demo/Sources/DefaultDemoCode.swift",
            templatePath: "Sources/DefaultDemoCode.swift.stencil"
        ),
        .file(
            path: "\(path)/Demo/Support/Info.plist",
            templatePath: "Sources/DemoInfo.plist.stencil"
        ),
    ]
)
