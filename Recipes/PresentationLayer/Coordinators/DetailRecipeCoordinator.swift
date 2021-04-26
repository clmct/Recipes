import UIKit

protocol DetailRecipeCoordinatorDelegate: AnyObject {
    func detailRecipeCoordinatorDidFinishWork()
}

final class DetailRecipeCoordinator: CoordinatorProtocol {
  weak var delegate: DetailRecipeCoordinatorDelegate?
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
extension DetailRecipeCoordinator: DetailRecipeViewModelDelegate {
  func showNetworkError(networkError: NetworkError, completion: @escaping () -> ()) {
    navigationController.showNetworkError(networkError: networkError) {
      completion()
    }
  }
  
  func closeViewController() {
    self.delegate?.detailRecipeCoordinatorDidFinishWork()
  }
  
  func showDetailRecipe(uuid: String) {
    let coordinator = DetailRecipeCoordinator(navigationController: navigationController,
                                        uuid: uuid,
                                        services: services)
    coordinator.start()
    childCoordinators.append(coordinator)
  }
  
  func showPhoto(image: UIImage) {
    let viewController = PhotosViewController(image: image)
    let viewModel = PhotosViewModel(photoLibraryService: services.photoLibraryService)
    viewController.viewModel = viewModel
    viewController.modalPresentationStyle = .fullScreen
    navigationController.present(viewController, animated: true, completion: nil)
  }
}
