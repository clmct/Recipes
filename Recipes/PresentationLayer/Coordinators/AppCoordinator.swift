import UIKit

final class AppCoordinator: CoordinatorProtocol {
  var navigationController: UINavigationController
  private var childCoordinators: [CoordinatorProtocol] = []
  private var services = ServiceAssembly()
  
  init() {
    self.navigationController = UINavigationController()
    self.navigationController.navigationBar.tintColor = .black
  }
  
  func start() {
    let coordinator = RecipesCoordinator(navigationController: navigationController, services: services)
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}
