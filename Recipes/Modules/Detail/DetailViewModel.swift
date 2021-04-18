import Foundation

protocol DetailRecipeViewModelProtocol {
  var recipe: RecipeElement? { get }
  var didFetchData: ((RecipeElement) -> ())? { get set }
  var didHud: ((HudType) -> ())? { get set }
  func fetchData()
}

final class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
  var uuid: String
  let networkService: NetworkServiceProtocol
  let router: RouterProtocol
  var recipe: RecipeElement?
  var didFetchData: ((RecipeElement) -> ())?
  var didHud: ((HudType) -> ())?
  
  init(uuid: String, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.uuid = uuid
    self.networkService = networkService
    self.router = router
  }
  
  func fetchData() {
    self.didHud?(.loader(type: .start))
    networkService.fetch(router: .getRecipe(id: uuid)) { (result: Result<Recipe, NetworkError>) in
      switch result {
      case.success(let recipe):
        self.recipe = recipe.recipe
        self.didFetchData?(recipe.recipe)
        self.didHud?(.loader(type: .stop))
      case .failure(let error):
        self.didHud?(.alert(type: error))
      }
    }
  }
  
  func showRecipe(id: String) {
    router.showDetailRecipe(uuid: id)
  }
  
}
