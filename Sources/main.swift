import Foundation
import Rainbow
import SwiftCLI
import Just
import SwiftyJSON

let host = "http://localhost:8080/"

func log(_ msg: String) {
  print("[Log] ".green + msg)
}

func err(_ msg: String) {
  print("[Err] ".red + msg)
}

func get(_ path: String) {
  handle(result: Just.get(host + path).json)
}

func post(_ path: String) {
  handle(result: Just.post(host + path).json)
}

func handle(result something: Any?) {
  if let result = something {
    log(String(describing: (["result": result] as JSON)))
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
_ = CLI.go()
