import Foundation

protocol ServiceAssemblyProtocol {
  var networkService: NetworkServiceProtocol { get }
  var photoLibraryService: PhotoLibraryServiceProtocol { get }
}

final class ServiceAssembly: ServiceAssemblyProtocol {
  var networkService: NetworkServiceProtocol  = NetworkService()
  var photoLibraryService: PhotoLibraryServiceProtocol = PhotoLibraryService()
}
