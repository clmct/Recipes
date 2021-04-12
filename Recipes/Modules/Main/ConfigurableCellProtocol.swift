import Foundation

protocol ConfigurableCellProtocol {
  associatedtype model
  func configure(with model: model)
}
