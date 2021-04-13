import Foundation
import os.log

struct Logger {
  
  static func noInternet() {
    let log = OSLog(subsystem: "RecipesApp", category: "Internet")
    os_log("No Internet", log: log, type: .default)
  }
  
  static func serverError() {
    let log = OSLog(subsystem: "RecipesApp", category: "Internet")
    os_log("Server Error", log: log, type: .default)
  }
  
}
