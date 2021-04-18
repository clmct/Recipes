import UIKit
import Kingfisher

final class RecipeTableViewCell: UITableViewCell {
  
  static var identifire = "RecipeTableViewCell"
  
  private lazy var imgView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .center
    image.layer.cornerRadius = 10
    image.layer.cornerCurve = .continuous
    image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    image.layer.masksToBounds = true
    return image
  }()
  
  private lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    title.font = .boldSystemFont(ofSize: 22)
    title.lineBreakMode = .byWordWrapping
    title.numberOfLines = 2
    return title
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let description = UILabel()
    description.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    description.font = .systemFont(ofSize: 13)
    description.lineBreakMode = .byWordWrapping
    description.numberOfLines = 2
    return description
  }()
  
  private lazy var dateLabel: UILabel = {
    let date = UILabel()
    date.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    date.numberOfLines = 2
    date.font = .systemFont(ofSize: 13)
    return date
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubviews()
    setupLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 0))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension RecipeTableViewCell: ConfigurableCellProtocol {
  typealias model = RecipeListElement
  func configure(with model: RecipeListElement) {
    titleLabel.text = model.name
    descriptionLabel.text = model.description
    dateLabel.text = model.lastUpdated.getDate()
    
    if let image = model.images.first,
       let url = URL(string: image) {
      imgView.kf.setImage(with: url)
    }
  }
}

private extension RecipeTableViewCell {
  
  func addSubviews() {
    contentView.addSubview(imgView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(dateLabel)
  }
  
  func setupLayout() {
    
    imgView.snp.makeConstraints { (make) in
      make.height.equalTo(112)
      make.width.equalTo(160)
      make.trailing.equalTo(contentView.snp.trailing)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(imgView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(imgView.snp.leading).offset(-15)
      make.height.lessThanOrEqualTo(55)
    }
    
    descriptionLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(titleLabel.snp.leading)
      make.trailing.equalTo(imgView.snp.leading).offset(-15)
      make.height.lessThanOrEqualTo(40)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(imgView.snp.bottom)
      make.leading.equalTo(titleLabel.snp.leading)
      make.trailing.equalTo(imgView.snp.leading).offset(-15)
    }
    
  }
  
}


