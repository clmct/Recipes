import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }

    let assembly = RootAssembly()
    let router = Router(assembly: assembly.presentationAssembly)
    
    let window = UIWindow(windowScene: scene)
    window.rootViewController = router.navigationController
    window.makeKeyAndVisible()
    self.window = window
  }
  
}

