import UIKit

protocol AssemblyProtocol {
  func createMainModule(router: RouterProtocol) -> UIViewController
  func createDetailModule(uuid: String,
                          router: RouterProtocol) -> UIViewController
  func createPhotoModule(image: UIImage) -> UIViewController
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
  
  func createPhotoModule(image: UIImage) -> UIViewController {
    let viewController = PhotoViewController(image: image)
    let viewModel = PhotoViewModel()
    viewController.viewModel = viewModel
    return viewController
  }
  
}
