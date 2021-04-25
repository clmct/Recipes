import UIKit

protocol RecipesViewModelDelegate: class {
  func showDetailRecipe(uuid: String)
  func showNetworkError(networkError: NetworkError, completion: @escaping (() -> ()) )
}

final class RecipesCoordinator: CoordinatorProtocol {
  private var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services: ServiceAssemblyProtocol
  
  init(navigationController: UINavigationController, services: ServiceAssemblyProtocol) {
    self.navigationController = navigationController
    self.services = services
  }
  
  func start() {
    let viewController = RecipesViewController()
    let viewModel = RecipesViewModel(networkService: services.networkService)
    viewModel.delegate = self
    viewController.viewModel = viewModel
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: RecipesViewModelDelegate
extension RecipesCoordinator: RecipesViewModelDelegate {
  func showNetworkError(networkError: NetworkError, completion: @escaping () -> ()) {
    navigationController.showHudError(networkError: networkError) {
      completion()
    }
  }
  
  func showDetailRecipe(uuid: String) {
    let coordinator = RecipeCoordinator(navigationController: navigationController,
                                        uuid: uuid, services: services)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }
}

// MARK: RecipeCoordinatorDelegate
extension RecipesCoordinator: RecipeCoordinatorDelegate {
  func recipeCoordinatorDidFinishWork() {
    childCoordinators.removeAll()
  }
}


