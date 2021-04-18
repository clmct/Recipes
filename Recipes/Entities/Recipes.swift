import Foundation

struct Recipes: Codable {
  let recipes: [RecipeListElement]
}

struct RecipeListElement: Codable {
  let uuid: String
  let name: String
  let images: [String]
  let lastUpdated: Int
  let description: String?
  let instructions: String
  let difficulty: Int
}

struct Recipe: Codable {
  let recipe: RecipeElement
}

struct RecipeElement: Codable {
  let uuid: String
  let name: String
  let images: [String]
  let lastUpdated: Int
  let description: String?
  let instructions: String
  let difficulty: Int
  let similar: [RecipeBrief]
}

struct RecipeBrief: Codable {
  let uuid: String
  let name: String
  let image: String
}
