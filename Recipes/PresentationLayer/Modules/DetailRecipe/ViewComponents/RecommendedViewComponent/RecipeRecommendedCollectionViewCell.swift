import UIKit
import SnapKit

class RecipeRecommendedCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "RecipeRecommendedCollectionViewCell"
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayput()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayput() {
    setupImageView()
    setupTitleLabel()
    
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    imageView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.leading.top.equalToSuperview().inset(8)
    }
  }
  
  private func setupImageView() {
    imageView.contentMode = .center
    imageView.layer.cornerRadius = 10
    imageView.layer.cornerCurve = .continuous
    imageView.layer.masksToBounds = true
  }
  private func setupTitleLabel() {
    titleLabel.textColor = .basic4
    titleLabel.font = .basic5
  }
}

// MARK: ConfigurableCellProtocol
extension RecipeRecommendedCollectionViewCell: ConfigurableCellProtocol {
  typealias model = RecipeBrief
  
  func configure(with model: RecipeBrief) {
    if let url = URL(string: model.image) {
      imageView.kf.setImage(with: url)
    }
    titleLabel.text = model.name
  }
}
