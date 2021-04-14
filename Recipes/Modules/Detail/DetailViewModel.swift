import Foundation

protocol DetailRecipeViewModelProtocol {
  var recipe: RecipeElement? { get }
  var didFetchData: ((RecipeElement) -> ())? { get set }
}

final class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
  var uuid: String
  let networkService: NetworkServiceProtocol
  let router: RouterProtocol
  var recipe: RecipeElement?
  var didFetchData: ((RecipeElement) -> ())?
  
  init(uuid: String, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.uuid = uuid
    self.networkService = networkService
    self.router = router
    fetchData(id: uuid)
  }
  
  func fetchData(id: String) {
    networkService.fetch(router: .getRecipe(id: id)) { (result: Result<Recipe, Error>) in
      switch result {
      case.success(let recipe):
        self.recipe = recipe.recipe
        self.didFetchData?(recipe.recipe)
      case .failure(let error):
        print(error)
      }
    }
  }
  
}
