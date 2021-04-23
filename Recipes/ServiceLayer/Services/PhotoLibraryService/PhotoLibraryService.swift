import UIKit
import Photos

protocol PhotoLibraryServiceProtocol {
  func save(title: String, photo: UIImage, completionHandler: @escaping (Bool, Error?) -> ())
}

class PhotoLibraryService {
  
  /// Create album with given title
  /// - Parameters:
  ///   - title: the title
  ///   - completionHandler: the completion handler
  private func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
    DispatchQueue.global(qos: .background).async {
      var placeholder: PHObjectPlaceholder?
      
      PHPhotoLibrary.shared().performChanges({
        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
      }, completionHandler: { (created, error) in
        var album: PHAssetCollection?
        if created {
          let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
          album = collectionFetchResult?.firstObject
        }
        
        completionHandler(album)
      })
    }
  }
  
  /// Get album with given title
  /// - Parameters:
  ///   - title: the title
  ///   - completionHandler: the completion handler
  private func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
    DispatchQueue.global(qos: .background).async { [weak self] in
      let fetchOptions = PHFetchOptions()
      fetchOptions.predicate = NSPredicate(format: "title = %@", title)
      let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
      
      if let album = collections.firstObject {
        completionHandler(album)
      } else {
        self?.createAlbum(withTitle: title, completionHandler: { (album) in
          completionHandler(album)
        })
      }
    }
  }
}

// MARK: PhotoLibraryServiceProtocol
extension PhotoLibraryService: PhotoLibraryServiceProtocol {
  func save(title: String, photo: UIImage, completionHandler: @escaping (Bool, Error?) -> ()) {
    getAlbum(title: title) { (album) in
      DispatchQueue.global(qos: .background).async {
        PHPhotoLibrary.shared().performChanges({
          let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
          let assets = assetRequest.placeholderForCreatedAsset
            .map { [$0] as NSArray } ?? NSArray()
          let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
          albumChangeRequest?.addAssets(assets)
        }, completionHandler: { (success, error) in
          completionHandler(success, error)
        })
      }
    }
  }
}
