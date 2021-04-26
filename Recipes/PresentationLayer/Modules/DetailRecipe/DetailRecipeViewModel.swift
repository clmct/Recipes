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

protocol DetailRecipeViewModelDelegate: class {
  func showDetailRecipe(uuid: String)
  func showPhoto(image: UIImage)
  func closeViewController()
  func showNetworkError(networkError: NetworkError, completion: @escaping (() -> ()) )
}

final class DetailRecipeViewModel: DetailRecipeViewModelProtocol {
  weak var delegate: DetailRecipeViewModelDelegate?
  var recipe: RecipeElement?
  var uuid: String
  var didFetchData: ((RecipeElement) -> ())?
  var didRequestLoader: ((LoaderAction) -> ())?
  let networkService: NetworkServiceProtocol
  
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
      case .failure(let networkError):
        DispatchQueue.main.async {
          self.delegate?.showNetworkError(networkError: networkError) { [weak self] in
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
