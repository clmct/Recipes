import UIKit

enum SortType {
  case name
  case date
}

protocol RecipesViewModelProtocol {
  var didUpdateViewModel: (() -> ())? { get set }
  func didSelect(index: Int)
  func fetchData()
  var filteredRecipes: [RecipeListElement] { get set }
  func updateSearchResults(searchController: UISearchController)
  func sort(type: SortType)
}

final class RecipesViewModel: RecipesViewModelProtocol {
  
  let networkService: NetworkServiceProtocol
  let router: RouterProtocol
  
  init(networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.networkService = networkService
    self.router = router
  }
  
  var didUpdateViewModel: (() -> ())?
  var recipes = [RecipeListElement]()
  var filteredRecipes = [RecipeListElement]()
  var isFiltering: Bool = false
  
  func didSelect(index: Int) {
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
    networkService.fetch(router: .getRecipes) { (result: Result<Recipes, Error>) in
      switch result {
      case.success(let recipes):
        self.recipes = recipes.recipes
        self.filteredRecipes = recipes.recipes.sorted { $0.name < $1.name }
        self.didUpdateViewModel?()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func updateSearchResults(searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    let index = searchController.searchBar.selectedScopeButtonIndex
    if text == "" {
      filteredRecipes = recipes
      self.didUpdateViewModel?()
      return
    }
    
    filteredRecipes = recipes.filter({ (recipe) -> Bool in
      switch index {
      case 0:
        return recipe.name.lowercased().contains(text.lowercased())
      case 1:
        if let description = recipe.description {
          return description.lowercased().contains(text.lowercased())
        } else {
          return false
        }
      case 2:
        return recipe.instructions.lowercased().contains(text.lowercased())
      default:
        return true
      }
    })
    self.didUpdateViewModel?()
  }
  
}

