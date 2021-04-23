import Foundation

struct RecipeListElement: Codable {
  let uuid: String
  let name: String
  let images: [String]
  let lastUpdated: Int
  let description: String?
  let instructions: String
  let difficulty: Int
}
