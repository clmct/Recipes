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
  
//  static func <(lhs: Recipe, rhs: Recipe) -> Bool {
//    return lhs.name < rhs.name
//  }
//  
//  static func >(lhs: Recipe, rhs: Recipe) -> Bool {
//    return lhs.lastUpdated > rhs.lastUpdated
//  }
}

