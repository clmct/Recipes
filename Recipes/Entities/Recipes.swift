import Foundation

struct Recipes: Codable {
  let recipes: [Recipe]
}

struct Recipe: Codable, Hashable {
  let uuid: String
  let name: String
  let images: [String]
  let lastUpdated: Int
  let description: String?
  let instructions: String
  let difficulty: Int
}
