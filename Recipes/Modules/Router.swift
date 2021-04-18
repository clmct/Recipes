import UIKit

protocol RouterProtocol {
  func showRecipes()
  func showDetailRecipe(uuid: String)
  func showPhoto(image: UIImage)
}

final class Router: RouterProtocol {
  
  let assembly: AssemblyProtocol
  var navigationController = UINavigationController()
  
  init(assembly: AssemblyProtocol) {
    self.assembly = assembly
    showRecipes()
  }
  
  func showRecipes() {
    let viewController = assembly.createMainModule(router: self)
    navigationController.viewControllers = [viewController]
  }
  
  func showDetailRecipe(uuid: String) {
    let viewController = assembly.createDetailModule(uuid: uuid,
                                                     router: self)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func showPhoto(image: UIImage) {
    let viewController = assembly.createPhotoModule(image: image)
    viewController.modalPresentationStyle = .fullScreen
    navigationController.present(viewController, animated: true, completion: nil)
  }
  
}
