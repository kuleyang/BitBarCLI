import Rainbow

struct Log {
  enum Level: String {
    case warning
    case info
    case error
    case verbose

    var type: String {
      let str = "[\(String(describing: self).capitalized)] "
      return str.padding(toLength: 10, withPad: " ", startingAt: 0)
    }
  }

  static func std(err: String, _ level: Log.Level) {
    if let data = (log(level, err) + "\n").data(using: .utf8) {
      stderr.write(data)
    } else {
      print("[Error] Coult not write to stderr")
    }
  }

  static func std(out: String, _ level: Log.Level) {
    print(log(level, out))
  }

  static func std(out: String, _ level: String) {
    std(out: out, to(level: level))
  }

  private static func to(level: String) -> Log.Level {
    switch level.lowercased() {
    case "warning":
      return .warning
    case "info":
      return .info
    case "error":
      return .error
    case "verbose":
      return .verbose
    default:
      return .info
    }
  }

  private static func log(_ level: Log.Level, _ msg: String) -> String {
    switch level {
    case .info:
      return level.type.blue + msg
    case .error:
      return level.type.red + msg
    case .warning:
      return level.type.yellow + msg
    case .verbose:
      return level.type.cyan + msg
    }
  }
}

