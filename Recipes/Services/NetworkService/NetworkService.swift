import Foundation

protocol NetworkServiceProtocol {
  func fetch<T: Codable>(router: NetworkRouter, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
  
  func fetch<T: Codable>(router: NetworkRouter, completion: @escaping (Result<T, Error>) -> Void) {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    
    guard let url = components.url else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method
    
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      guard error == nil else {
        print(error?.localizedDescription as Any)
        return
      }
      guard response != nil else {
        print("no response")
        return
      }
      guard let data = data else {
        print("no data")
        return
      }
      
      if (response as? HTTPURLResponse)?.statusCode == 200, error == nil {
        do {
          let jsonObject = try JSONDecoder().decode(T.self, from: data)
          completion(.success(jsonObject))
        } catch let error {
          print(error)
        }
      }
      
    }.resume()
  }
}
