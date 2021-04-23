import UIKit

protocol DetailRecipeViewModelProtocol {
  var recipe: RecipeElement? { get }
  var didFetchData: ((RecipeElement) -> ())? { get set }
  var didRequestShowHUD: ((NetworkError) -> ())? { get set }
  var didRequestLoader: ((LoaderAction) -> ())? { get set }
  func fetchData()
  func showRecipe(id: String)
  func showPhoto(image: UIImage)
}

final class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
  var uuid: String
  let networkService: NetworkServiceProtocol
  var router: RouterProtocol
  var recipe: RecipeElement?
  var didFetchData: ((RecipeElement) -> ())?
  var didRequestShowHUD: ((NetworkError) -> ())?
  var didRequestLoader: ((LoaderAction) -> ())?
  
  init(uuid: String, networkService: NetworkServiceProtocol, router: RouterProtocol) {
    self.uuid = uuid
    self.networkService = networkService
    self.router = router
  }
  
  func fetchData() {
    self.didRequestLoader?(.start)
    networkService.getRecipe(id: uuid) { (result: Result<Recipe, NetworkError>) in
      switch result {
      case.success(let recipe):
        self.recipe = recipe.recipe
        DispatchQueue.main.async {
          self.didFetchData?(recipe.recipe)
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
  
  func showRecipe(id: String) {
    router.showDetailRecipe(uuid: id)
  }
  
  func showPhoto(image: UIImage) {
    router.showPhoto(image: image)
  }
  
}
