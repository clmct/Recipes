import Foundation

extension Int {
  /// Returns the date type "dd.MM.yyyy"
  func getDate() -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(self))
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
  }
}


