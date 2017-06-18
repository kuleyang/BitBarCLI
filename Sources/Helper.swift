import Just
import Foundation
import SwiftyJSON

let stderr = FileHandle.standardError
let hostDomain = "localhost:9112"
let host = "http://\(hostDomain)"

func info(_ msg: String) {
  Log.std(out: msg, .info)
}

func log(_ msg: String) -> Never {
  Log.std(err: msg, .info)
  exit(0)
}

func err(_ msg: String) -> Never {
  Log.std(err: msg, .error)
  exit(1)
}

func get(_ path: String) {
  perform({ Just.get($0) }, path)
}

func delete(_ path: String) {
  perform({ Just.delete($0) }, path)
}

func patch(_ path: String) {
  perform({ Just.patch($0) }, path)
}

func post(_ path: String) {
  perform({ Just.post($0) }, path)
}

func perform(_ request: (String) -> HTTPResult, _ path: String) {
  handle(request(host + path), path)
}

func handle(_ request: HTTPResult, _ path: String) {
  switch request.statusCode {
  case .none:
    err("(-1) Could not connect to BitBar, is the app running on \(hostDomain)?")
  case .some(404):
    if let method = request.request?.httpMethod {
      err("(404) Path \(method) '\(path)' not found")
    } else {
      err("(404) Path '\(path)' not found")
    }
  case .some(200): break
  case let .some(code):
    if let output = request.text {
      err("(\(code)) Unknown status code returned from server: \(output)")
    } else {
      err("(\(code)) Unknown status code returned with no output")
    }
  }

  guard let result = request.json else {
    err("(1) No JSON returned from server")
  }

  print(String(describing: ["result": result] as JSON))
}