import UIKit

protocol AssemblyProtocol {
  func createMainModule(router: RouterProtocol) -> UIViewController
  func createDetailModule(uuid: String,
                          router: RouterProtocol) -> UIViewController
}

final class Assembly: AssemblyProtocol {
  
  let networkService = NetworkService()
  
  func createMainModule(router: RouterProtocol) -> UIViewController {
    let viewController = RecipesViewController()
    let viewModel = RecipesViewModel(networkService: networkService, router: router)
    viewController.viewModel = viewModel
    return viewController
  }
  
  func createDetailModule(uuid: String, router: RouterProtocol) -> UIViewController {
    let viewController = DetailRecipeViewController()
    let viewModel = DetailRecipeViewModel(uuid: uuid, networkService: networkService, router: router)
    viewController.viewModel = viewModel
    return viewController
  }
  
}
