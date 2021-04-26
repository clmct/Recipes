import UIKit

protocol NetworkErrorShowingProtocol {}
extension NetworkErrorShowingProtocol where Self: UINavigationController {
  func showNetworkError(networkError: NetworkError,
                    completion: @escaping () -> ()) {
    
    let networkErrorVC = NetworkErrorViewController(networkError: .noInternet)
    networkErrorVC.didRefresh = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      completion()
    }
    networkErrorVC.modalPresentationStyle = .fullScreen
    present(networkErrorVC, animated: true, completion: nil)
  }
}

