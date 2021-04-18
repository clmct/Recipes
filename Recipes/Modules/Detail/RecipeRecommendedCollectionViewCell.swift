import UIKit
import SnapKit

class RecipeRecommendedCollectionViewCell: UICollectionViewCell {
    
  static var identifire = "RecipeRecommendedCollectionViewCell"
  
  private lazy var imgView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .center
    image.image = UIImage(named: "Bitmap")
    image.layer.cornerRadius = 10
    image.layer.cornerCurve = .continuous
    image.layer.masksToBounds = true
    return image
  }()
  
  private lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.text = "Banana Outmeal"
    title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    title.font = .systemFont(ofSize: 16)
    return title
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayput()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayput() {
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


extension RecipeRecommendedCollectionViewCell: ConfigurableCellProtocol {
  typealias model = RecipeBrief
  
  func configure(with model: RecipeBrief) {
    if let url = URL(string: model.image) {
      imgView.kf.setImage(with: url)
    }
    titleLabel.text = model.name
  }
}
