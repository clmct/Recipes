import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }

    let assembly = Assembly()
    let router = Router(assembly: assembly)
    
    let window = UIWindow(windowScene: scene)
    window.rootViewController = router.navigationController
    router.navigationController.navigationBar.tintColor = .black
    window.makeKeyAndVisible()
    self.window = window
  }
  
}

