import PackageDescription

let package = Package(
    name: "SMLDemo",
    dependencies: [.Package(url: "https://github.com/michael-yuji/SML.git", versions: Version(0,0,0)..<Version(1,0,0))]
)
