import UIKit

protocol DetailRecipeViewModelProtocol {
  var recipe: RecipeElement? { get }
  var didFetchData: ((RecipeElement) -> ())? { get set }
  var didRequestLoader: ((LoaderAction) -> ())? { get set }
  func fetchData()
  func showRecipe(id: String)
  func showPhoto(image: UIImage)
  func closeViewController()
}

final class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
  var uuid: String
  let networkService: NetworkServiceProtocol
  var recipe: RecipeElement?
  weak var delegate: RecipeViewModelDelegate?
  var didFetchData: ((RecipeElement) -> ())?
  var didRequestLoader: ((LoaderAction) -> ())?

  init(uuid: String, networkService: NetworkServiceProtocol) {
    self.uuid = uuid
    self.networkService = networkService
  }
  
  func closeViewController() {
    delegate?.closeViewController()
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
          self.delegate?.showNetworkError(networkError: error) { [weak self] in
            self?.fetchData()
          }
          self.didRequestLoader?(.stop)
        }
      }
    }
  }
  
  func showRecipe(id: String) {
    delegate?.showDetailRecipe(uuid: id)
  }
  
  func showPhoto(image: UIImage) {
    delegate?.showPhoto(image: image)
  }
  
}
