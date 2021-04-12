import UIKit

protocol AssemblyProtocol {
  func createMainModule() -> UIViewController
  func createDetailModule() -> UIViewController
}

final class Assembly: AssemblyProtocol {
  
  func createMainModule() -> UIViewController {
    let viewController = MainViewController()
    return viewController
  }
  
  func createDetailModule() -> UIViewController {
    let viewController = DetailViewController()
    return viewController
  }
  
}
