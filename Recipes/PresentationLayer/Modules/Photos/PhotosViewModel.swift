import UIKit
import Photos

protocol PhotosViewModelProtocol {
  func save(photo: UIImage, completionHandler: @escaping (Error?) -> ())
}

final class PhotosViewModel: PhotosViewModelProtocol {
  private var photoLibraryService: PhotoLibraryServiceProtocol
  
  init(photoLibraryService: PhotoLibraryServiceProtocol) {
    self.photoLibraryService = photoLibraryService
  }
  
  func save(photo: UIImage, completionHandler: @escaping (Error?) -> ()) {
    photoLibraryService.save(title: "pictures", photo: photo) { (_, error) in
      completionHandler(error)
    }
  }
  
}
