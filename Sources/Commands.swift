import SwiftCLI

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
