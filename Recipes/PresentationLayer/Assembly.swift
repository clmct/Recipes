import UIKit

protocol PresentationAssemblyProtocol {
  func createMainModule(router: RouterProtocol) -> UIViewController
  func createDetailModule(uuid: String,
                          router: RouterProtocol) -> UIViewController
  func createPhotoModule(image: UIImage) -> UIViewController
}

final class PresentationAssembly: PresentationAssemblyProtocol {
  private let serviceAssembly: ServiceAssemblyProtocol
  
  init(serviceAssembly: ServiceAssemblyProtocol) {
    self.serviceAssembly = serviceAssembly
  }
  
  func createMainModule(router: RouterProtocol) -> UIViewController {
    let viewController = RecipesViewController()
    let viewModel = RecipesViewModel(networkService: serviceAssembly.networkService, router: router)
    viewController.viewModel = viewModel
    return viewController
  }
  
  func createDetailModule(uuid: String, router: RouterProtocol) -> UIViewController {
    let viewController = DetailRecipeViewController()
    let viewModel = DetailRecipeViewModel(uuid: uuid, networkService: serviceAssembly.networkService, router: router)
    viewController.viewModel = viewModel
    return viewController
  }
  
  func createPhotoModule(image: UIImage) -> UIViewController {
    let viewController = PhotoViewController(image: image)
    let viewModel = PhotoViewModel(photoLibraryService: serviceAssembly.photoLibraryService)
    viewController.viewModel = viewModel
    return viewController
  }
  
}
