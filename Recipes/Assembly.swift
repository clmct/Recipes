import UIKit

protocol AssemblyProtocol {
  func createMainModule(router: RouterProtocol) -> UIViewController
  func createDetailModule() -> UIViewController
}

final class Assembly: AssemblyProtocol {
  
  func createMainModule(router: RouterProtocol) -> UIViewController {
    let n = NetworkService()
    
    let viewController = RecipesViewController()
    let viewModel = RecipesViewModel(networkService: n, router: router)
    viewController.viewModel = viewModel
    return viewController
  }
  
  func createDetailModule() -> UIViewController {
    let viewController = DetailViewController()
    return viewController
  }
  
}
