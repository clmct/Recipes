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
}
