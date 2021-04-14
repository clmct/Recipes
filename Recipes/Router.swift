import UIKit

protocol RouterProtocol {
  func showRecipes()
  func showDetailRecipe(uuid: String)
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
  
}
