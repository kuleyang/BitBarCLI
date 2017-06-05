// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "BitBarCli",
  dependencies: [
    .Package(url: "https://github.com/jakeheis/SwiftCLI.git", "3.0.1"),
    .Package(url: "https://github.com/onevcat/Rainbow", "2.0.1"),
    .Package(url: "https://github.com/JustHTTP/Just.git", "0.6.0"),
    .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", "3.1.4"),
    .Package(url: "https://github.com/daltoniam/Starscream.git", "2.0.4"),
    .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", "3.1.4")
  ]
)
