import Foundation
import os.log

struct Logger {
    
  static func serverError(messageLog: String) {
    let log = OSLog(subsystem: "RecipesApp", category: "Networking")
    os_log("%s", log: log, type: .error, messageLog)
  }
  
}
