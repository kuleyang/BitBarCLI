import SwiftCLI
import Foundation
import SwiftyJSON
import Starscream

class InvokePluginCommand: Command {
  let name = "plugin:invoke"
  let plugin = Parameter()
  let args = CollectedParameter()
  let shortDescription = "Invoke plugin"

  func execute() throws {
    patch("/plugin/\(plugin.value)/args/\(args.value.joined(separator: "/"))/invoke")
  }
}

class ShowPluginCommand: Command {
  let name = "plugin:show"
  let plugin = Parameter()
  let shortDescription = "Make plugin visible"

  func execute() throws {
    patch("/plugin/\(plugin.value)/show")
  }
}

class HidePluginCommand: Command {
  let name = "plugin:hide"
  let plugin = Parameter()
  let shortDescription = "Hide plugin"

  func execute() throws {
    patch("/plugin/\(plugin.value)/hide")
  }
}

class InfoPluginCommand: Command {
  let name = "plugin"
  let plugin = Parameter()
  let shortDescription = "Display info about a plugin"

  func execute() throws {
    get("/plugin/\(plugin.value)")
  }
}

class RefreshPluginCommand: Command {
  let name = "plugin:refresh"
  let plugin = Parameter()
  let shortDescription = "Refresh plugin"

  func execute() throws {
    patch("/plugin/\(plugin.value)/refresh")
  }
}

class ListPluginsCommand: Command {
  let name = "plugins:list"
  let shortDescription = "List plugins"

  func execute() throws {
    get("/plugins")
  }
}

class RefreshPluginsCommand: Command {
  let name = "plugins:refresh"
  let shortDescription = "Refresh all plugins"

  func execute() throws {
    patch("/plugins/refresh")
  }
}

class GetStoreValueCommand: Command {
  let name = "plugin:store:get"
  let plugin = Parameter()
  let key = Parameter()
  let `default` = Parameter()
  let shortDescription = "Get value from store"

  func execute() throws {
    get("/plugin/\(plugin.value)/store/key/\(key.value)/default/\(`default`.value)")
  }
}

class SetStoreValueCommand: Command {
  let name = "plugin:store:set"
  let plugin = Parameter()
  let key = Parameter()
  let value = Parameter()
  let shortDescription = "Set value from store"

  func execute() throws {
    patch("/plugin/\(plugin.value)/store/key/\(key.value)/value/\(value.value)")
  }
}

class PushStoreValueCommand: Command {
  let name = "plugin:store:push"
  let plugin = Parameter()
  let value = Parameter()
  let shortDescription = "Push value to local storage"

  func execute() throws {
    patch("/plugin/\(plugin.value)/store/list/\(value.value)")
  }
}

class GetValueValueCommand: Command {
  let name = "plugin:store:ret"
  let plugin = Parameter()
  let shortDescription = "Get value to local storage"

  func execute() throws {
    get("/plugin/\(plugin.value)/store/list")
  }
}

class ClearListCommand: Command {
  let name = "plugin:store:clear"
  let plugin = Parameter()
  let shortDescription = "Clear list"

  func execute() throws {
    delete("/plugin/\(plugin.value)/store/list")
  }
}

class LogPluginCommand: Command {
  let name = "log"
  let shortDescription = "Live stream of application log"
  let path = "ws://\(hostDomain)/log"

  func execute() throws {
    guard let url = URL(string: path) else {
      err("Could not connect to \(path)")
    }

    let socket = WebSocket(url: url)
    socket.onConnect = {
      info("Connected to BitBar, waiting for output...")
    }

    socket.onDisconnect = { (error: NSError?) in
      if let msg = error {
        err("Disconnect due to error: \(msg.localizedDescription)")
      } else {
        log("Disconnect from host")
      }
    }

    socket.onText = { raw in
      guard let data = raw.data(using: .utf8) else {
        return Log.std(err: "Could not convert websocket data", .error)
      }
      let json = JSON(data: data)
      let level = json["level"].string ?? "warning"
      let message = json["message"].string ?? raw
      Log.std(out: message, level)
    }

    socket.connect()
    CFRunLoopRun()
  }
}
