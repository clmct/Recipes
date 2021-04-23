import UIKit
import SnapKit

class RecipeRecommendedCollectionViewCell: UICollectionViewCell {
    
  static var identifier = "RecipeRecommendedCollectionViewCell"
  
  private var imgView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .center
    image.layer.cornerRadius = 10
    image.layer.cornerCurve = .continuous
    image.layer.masksToBounds = true
    return image
  }()
  
  private var titleLabel: UILabel = {
    let title = UILabel()
    title.textColor = .basic4
    title.font = .basic5
    return title
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayput()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayput() {
    contentView.addSubview(imgView)
    imgView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    imgView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.leading.top.equalToSuperview().inset(8)
    }
  }
}

// MARK: ConfigurableCellProtocol
extension RecipeRecommendedCollectionViewCell: ConfigurableCellProtocol {
  typealias model = RecipeBrief
  
  func configure(with model: RecipeBrief) {
    if let url = URL(string: model.image) {
      imgView.kf.setImage(with: url)
    }
    titleLabel.text = model.name
  }
}
