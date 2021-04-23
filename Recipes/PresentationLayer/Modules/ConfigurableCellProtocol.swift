import Foundation

protocol ConfigurableCellProtocol {
  associatedtype Model
  func configure(with model: Model)
}
