import Foundation

enum NetworkRouter {
  
  case getRecipes
  
  var scheme: String {
    switch self {
    case .getRecipes:
      return "https"
    }
  }

  var host: String {
    let base = "test.kode-t.ru"
    switch self {
    case .getRecipes:
      return base
    }
  }

  var path: String {
    switch self {
    case .getRecipes:
      return "/recipes.json"
    }
  }
  
  var method: String {
      switch self {
        case .getRecipes:
          return "GET"
      }
    }
}

