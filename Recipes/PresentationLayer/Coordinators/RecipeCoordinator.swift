import UIKit

protocol RecipeCoordinatorDelegate: AnyObject {
    func recipeCoordinatorDidFinishWork()
}

protocol RecipeViewModelDelegate: class {
  func showDetailRecipe(uuid: String)
  func showPhoto(image: UIImage)
  func closeViewController()
  func showNetworkError(networkError: NetworkError, completion: @escaping (() -> ()) )
}

final class RecipeCoordinator: CoordinatorProtocol {
  weak var delegate: RecipeCoordinatorDelegate?
  private var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services: ServiceAssemblyProtocol
  private var uuid: String
  
  init(navigationController: UINavigationController,
       uuid: String,
       services: ServiceAssemblyProtocol) {
    self.navigationController = navigationController
    self.uuid = uuid
    self.services = services
  }
  
  func start() {
    let viewController = DetailRecipeViewController()
    let viewModel = DetailRecipeViewModel(uuid: uuid,
                                          networkService: services.networkService)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: RecipeViewModelDelegate
extension RecipeCoordinator: RecipeViewModelDelegate {
  func showNetworkError(networkError: NetworkError, completion: @escaping () -> ()) {
    navigationController.showHudError(networkError: networkError) {
      completion()
    }
  }
  
  func closeViewController() {
    self.delegate?.recipeCoordinatorDidFinishWork()
  }
  
  func showDetailRecipe(uuid: String) {
    let coordinator = RecipeCoordinator(navigationController: navigationController,
                                        uuid: uuid,
                                        services: services)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
  
  func showPhoto(image: UIImage) {
    let viewController = PhotoViewController(image: image)
    let viewModel = PhotoViewModel(photoLibraryService: services.photoLibraryService)
    viewController.viewModel = viewModel
    viewController.modalPresentationStyle = .fullScreen
    navigationController.present(viewController, animated: true, completion: nil)
  }
}
