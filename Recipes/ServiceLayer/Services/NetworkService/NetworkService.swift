import Foundation
import Network

enum NetworkError: Error {
  case serverResponse
  case noInternet
}

protocol NetworkServiceProtocol {
  func getRecipes(completion: @escaping (Result<Recipes, NetworkError>) -> Void)
  func getRecipe(id: String, completion: @escaping (Result<Recipe, NetworkError>) -> Void)
}

final class NetworkService {
  private func fetch<T: Codable>(router: NetworkRouter, completion: @escaping (Result<T, NetworkError>) -> Void) {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    
    guard let url = components.url else {
      completion(.failure(.serverResponse))
      Logger.serverError(messageLog: "url error")
      return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method
    
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    config.timeoutIntervalForResource = 60
    
    URLSession(configuration: config).dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        completion(.failure(.noInternet))
        Logger.serverError(messageLog: error.debugDescription)
        return
      }
      
      guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
        completion(.failure(.serverResponse))
        Logger.serverError(messageLog: "response error, status is not succes")
        return
      }
      
      guard let data = data else {
        completion(.failure(.serverResponse))
        Logger.serverError(messageLog: response.debugDescription)
        return
      }
      
      if response.statusCode == 200 {
        do {
          let jsonObject = try JSONDecoder().decode(T.self, from: data)
          completion(.success(jsonObject))
        } catch {
          completion(.failure(.serverResponse))
          Logger.serverError(messageLog: response.debugDescription)
        }
      } else {
        completion(.failure(.serverResponse))
        Logger.serverError(messageLog: response.description)
      }
      
    }.resume()
  }
}

// MARK: NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
  func getRecipes(completion: @escaping (Result<Recipes, NetworkError>) -> Void) {
    self.fetch(router: .getRecipes) { (result: Result<Recipes, NetworkError>) in
      completion(result)
    }
  }
  
  func getRecipe(id: String, completion: @escaping (Result<Recipe, NetworkError>) -> Void) {
    self.fetch(router: .getRecipe(id: id)) { (result: Result<Recipe, NetworkError>) in
      completion(result)
    }
  }
}
