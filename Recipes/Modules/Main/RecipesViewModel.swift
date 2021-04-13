import Foundation

protocol RecipesViewModelProtocol {
  var didFetchData: (() -> ())? { get set }
  func fetchData()
  var recipes: [Recipe] { get set }
}

final class RecipesViewModel: RecipesViewModelProtocol {
  
  let networkService: NetworkServiceProtocol
  let router: RouterProtocol
  
  init(networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.networkService = networkService
    self.router = router
  }
  
  var didFetchData: (() -> ())?
  var recipes = [Recipe]()
  
  func fetchData() {
    networkService.fetch(router: .getRecipes) { (result: Result<Recipes, Error>) in
      switch result {
      case.success(let recipes):
        self.recipes = recipes.recipes
      case .failure(let error):
        print(error)
      }
    }
  }
  
}

