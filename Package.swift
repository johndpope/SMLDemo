import PackageDescription

let package = Package(
    name: "SMLDemo",
    dependencies: [.Package(url: "https://github.com/projectSX0/SML.git", versions: Version(0,0,0)..<Version(1,0,0))]
)
