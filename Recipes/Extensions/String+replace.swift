import Foundation

extension String {
  /// Replace <br> to \n
  func replace(target: String = "<br>", withString: String = "\n") -> String {
    return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
  }
}
