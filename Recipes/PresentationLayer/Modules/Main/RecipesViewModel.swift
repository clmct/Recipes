import UIKit

enum SortType {
  case name
  case date
}

enum LoaderAction {
  case start
  case stop
}

protocol RecipesViewModelProtocol {
  var didUpdateViewModel: (() -> ())? { get set }
  var didRequestShowHUD: ((NetworkError) -> ())? { get set }
  var didRequestLoader: ((LoaderAction) -> ())? { get set }
  var filteredRecipes: [RecipeListElement] { get set }
  func updateSearchResults(text: String, index: Int)
  func sort(type: SortType)
  func select(index: Int)
  func fetchData()
}

final class RecipesViewModel: RecipesViewModelProtocol {
  let networkService: NetworkServiceProtocol
  let router: RouterProtocol
  var didRequestShowHUD: ((NetworkError) -> ())?
  var didUpdateViewModel: (() -> ())?
  var recipes = [RecipeListElement]()
  var filteredRecipes = [RecipeListElement]()
  var didRequestLoader: ((LoaderAction) -> ())?
  
  init(networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.networkService = networkService
    self.router = router
  }
  
  func select(index: Int) {
    router.showDetailRecipe(uuid: filteredRecipes[index].uuid)
  }
  
  func sort(type: SortType) {
    switch type {
    case .name:
      filteredRecipes.sort { $0.name < $1.name }
    case .date:
      filteredRecipes.sort { $0.lastUpdated > $1.lastUpdated }
    }
    self.didUpdateViewModel?()
  }
  
  func fetchData() {
    didRequestLoader?(.start)
    networkService.getRecipes { (result: Result<Recipes, NetworkError>) in
      switch result {
      case.success(let recipes):
        self.recipes = recipes.recipes
        self.filteredRecipes = recipes.recipes.sorted { $0.name < $1.name }
        DispatchQueue.main.async {
          self.didUpdateViewModel?()
          self.didRequestLoader?(.stop)
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.didRequestShowHUD?(error)
          self.didRequestLoader?(.stop)
        }
      }
    }
  }
  
  func updateSearchResults(text: String, index: Int) {
    if text == "" {
      filteredRecipes = recipes
      self.didUpdateViewModel?()
      return
    }
    
    filteredRecipes = recipes.filter { recipe -> Bool in
      let index = Constants.FilterIndex.init(rawValue: index)
      switch index {
      case .nameFilterIndex:
        return recipe.name.lowercased().contains(text.lowercased())
      case .descriptionFilterIndex:
        if let description = recipe.description {
          return description.lowercased().contains(text.lowercased())
        } else {
          return false
        }
      case .instructionFilterIndex:
        return recipe.instructions.lowercased().contains(text.lowercased())
      default:
        return true
      }
    }
    self.didUpdateViewModel?()
  }
}


