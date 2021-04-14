import Foundation

enum NetworkRouter {
  
  case getRecipes
  case getRecipe(id: String)
  
  var scheme: String {
    switch self {
    case .getRecipes, .getRecipe:
      return "https"
    }
  }

  var host: String {
    let base = "test.kode-t.ru"
    switch self {
    case .getRecipes, .getRecipe:
      return base
    }
  }

  var path: String {
    switch self {
    case .getRecipes:
      return "/recipes"
    case .getRecipe(let id):
      return "/recipes/" + id
    }
  }
  
  var method: String {
    switch self {
    case .getRecipes, .getRecipe:
      return "GET"
    }
  }
  
}

