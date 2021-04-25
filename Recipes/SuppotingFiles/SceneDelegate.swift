import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator = AppCoordinator()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: scene)
    window.rootViewController = appCoordinator.navigationController
    window.makeKeyAndVisible()
    self.window = window
    appCoordinator.start()
  }
  
}

