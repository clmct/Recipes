import UIKit

protocol RouterProtocol {
  func showRecipes()
  func showDetailRecipe()
}

final class Router: RouterProtocol {
  
  let assembly: AssemblyProtocol
  var navigationController = UINavigationController()
  
  init(assembly: AssemblyProtocol) {
    self.assembly = assembly
    showRecipes()
  }
  
  func showRecipes() {
    let viewController = assembly.createMainModule()
    navigationController.viewControllers = [viewController]
  }
  
  func showDetailRecipe() {
    let viewController = assembly.createDetailModule()
    navigationController.pushViewController(viewController, animated: true)
  }
  
}
