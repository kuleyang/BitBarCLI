import SwiftCLI
import Foundation
import Starscream

class InvokePluginCommand: Command {
  let name = "plugin:invoke"
  let plugin = Parameter()
  let args = CollectedParameter()
  let shortDescription = "Invoke plugin"

  func execute() throws {
    post("/plugin/\(plugin.value)/args/\(args.value.joined(separator: "/"))/invoke")
  }
}

class ShowPluginCommand: Command {
  let name = "plugin:show"
  let plugin = Parameter()
  let shortDescription = "Make plugin visible"

  func execute() throws {
    post("/plugin/\(plugin.value)/show")
  }
}

class HidePluginCommand: Command {
  let name = "plugin:hide"
  let plugin = Parameter()
  let shortDescription = "Hide plugin"

  func execute() throws {
    post("/plugin/\(plugin.value)/hide")
  }
}

class RefreshPluginCommand: Command {
  let name = "plugin:refresh"
  let plugin = Parameter()
  let shortDescription = "Refresh plugin"

  func execute() throws {
    post("/plugin/\(plugin.value)/refresh")
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
    post("/plugins/refresh")
  }
}

class GetStoreValueCommand: Command {
  let name = "plugin:store:get"
  let plugin = Parameter()
  let key = Parameter()
  let `default` = Parameter()
  let shortDescription = "Get value from store"

  func execute() throws {
    raw("/plugin/\(plugin.value)/store/key/\(key.value)/default/\(`default`.value)")
  }
}

class SetStoreValueCommand: Command {
  let name = "plugin:store:set"
  let plugin = Parameter()
  let key = Parameter()
  let value = Parameter()
  let shortDescription = "Set value from store"

  func execute() throws {
    post("/plugin/\(plugin.value)/store/key/\(key.value)/value/\(value.value)")
  }
}

class PushStoreValueCommand: Command {
  let name = "plugin:store:push"
  let plugin = Parameter()
  let value = Parameter()
  let shortDescription = "Push value to local storage"

  func execute() throws {
    post("/plugin/\(plugin.value)/store/list/\(value.value)")
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
  let name = "plugin:log"
  let plugin = Parameter()
  let shortDescription = "Live loggin for plugin"

  func execute() throws {
    guard let url = URL(string: "ws://\(hostDomain)/plugin/\(plugin.value)/log") else {
      return err("Could not create socket path")
    }

    let socket = WebSocket(url: url)
    socket.onConnect = {
      log("Connected to '\(self.plugin.value)', awaiting stream…")
    }

    socket.onDisconnect = { (error: NSError?) in
      if let msg = error {
        err("Disconnect due to error: \(msg.localizedDescription)")
        exit(1)
      } else {
        log("Disconnect from host")
        exit(0)
      }
    }

    socket.onText = log
    socket.connect()
    CFRunLoopRun()
  }
}
