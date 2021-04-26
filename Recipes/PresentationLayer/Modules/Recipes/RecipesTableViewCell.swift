import UIKit
import Kingfisher

final class RecipeTableViewCell: UITableViewCell {
  
  // MARK: Properties
  static let identifier = "RecipeTableViewCell"
  private let imgView = UIImageView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let dateLabel = UILabel()
  
  // MARK: Life Cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 0))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Methods
  private func getDate(data: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(data))
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
  }
  
  private func setupImageView() {
    imgView.contentMode = .center
    imgView.layer.cornerRadius = 10
    imgView.layer.cornerCurve = .continuous
    imgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    imgView.layer.masksToBounds = true
  }
  
  private func setupTitleLabel() {
    titleLabel.textColor = .basic1
    titleLabel.font = .basic2
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 2
  }
  
  
  private func setupDescriptionLabel() {
    descriptionLabel.textColor = .basic2
    descriptionLabel.font = .basic3
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.numberOfLines = 2
  }
  
  private func setupDateLabel() {
    dateLabel.textColor = .basic1
    dateLabel.numberOfLines = 2
    dateLabel.font = .basic3
  }
  
  
  private func setupLayout() {
    setupImageView()
    setupTitleLabel()
    setupDescriptionLabel()
    setupDateLabel()
    
    contentView.addSubview(imgView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(dateLabel)
    
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

// MARK: ConfigurableCellProtocol
extension RecipeTableViewCell: ConfigurableCellProtocol {
  typealias model = RecipeListElement
  func configure(with model: RecipeListElement) {
    titleLabel.text = model.name
    descriptionLabel.text = model.description
    dateLabel.text = getDate(data: model.lastUpdated)
    
    if let image = model.images.first,
       let url = URL(string: image) {
      imgView.kf.setImage(with: url)
    }
  }
}
