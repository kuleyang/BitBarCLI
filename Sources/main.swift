import Foundation
import Rainbow
import SwiftCLI
import Just
import SwiftyJSON
let stderr = FileHandle.standardError
let hostDomain = "localhost:8080"
let host = "http://\(hostDomain)"

func log(_ msg: String) {
  let string = ("[Log] ".green + msg + "\n")
  if let data = string.data(using: .utf8) {
    stderr.write(data)
  }
}

func err(_ msg: String) {
  let string = ("[Err] ".red + msg + "\n")
  if let data = string.data(using: .utf8) {
    stderr.write(data)
  }
}

func get(_ path: String) {
  log("Calling(get): \(host + path)")
  handle(result: Just.get(host + path).json)
}

func delete(_ path: String) {
  log("Calling(delete): \(host + path)")
  handle(result: Just.delete(host + path).json)
}

func raw(_ path: String) {
  log("Calling(raw): \(host + path)")
  if let output = Just.get(host + path).text {
    return print(output)
  }

  err("No output from server")
  exit(1)
}

func post(_ path: String) {
  log("Calling(post): \(host + path)")
  handle(result: Just.post(host + path).json)
}

func handle(result something: Any?) {
  if let result = something {
    print(String(describing: (["result": result] as JSON)))
  } else {
    err("No data from server")
  }
}

CLI.setup(name: "BitBar", version: "1.0.beta", description: "CLI for BitBar")
CLI.register(command: ShowPluginCommand())
CLI.register(command: HidePluginCommand())
CLI.register(command: InvokePluginCommand())
CLI.register(command: RefreshPluginsCommand())
CLI.register(command: ListPluginsCommand())
CLI.register(command: GetStoreValueCommand())
CLI.register(command: SetStoreValueCommand())
CLI.register(command: RefreshPluginCommand())
CLI.register(command: PushStoreValueCommand())
CLI.register(command: GetValueValueCommand())
CLI.register(command: ClearListCommand())
CLI.register(command: LogPluginCommand())
_ = CLI.go()