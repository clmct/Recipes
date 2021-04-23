import Foundation

struct Constants {
  enum FilterIndex: Int {
    case nameFilterIndex
    case descriptionFilterIndex
    case instructionFilterIndex
  }
  
  enum Filter: String {
    case nameFilterIndex = "Name"
    case descriptionFilterIndex = "Description"
    case instructionFilterIndex = "Instruction"
  }
  
  enum NoInternet: String {
    case title = "No internet"
    case description = "Try refreshing the screen when communication is restored."
  }
  
  enum SomethingWentWrong: String {
    case title = "Something went wrong"
    case description = "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
  }
}
