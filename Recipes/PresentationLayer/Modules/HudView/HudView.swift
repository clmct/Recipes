import UIKit
import SnapKit

final class HudView: UIView {
  
  private var refreshButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Refresh", for: .normal)
    button.setTitleColor(.basic3, for: .normal)
    button.layer.cornerRadius = 22
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.basic3.cgColor
    return button
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .basic5
    label.font = .basic6
    label.textAlignment = .center
    return label
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .basic5
    label.font = .basic5
    label.textAlignment = .center
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.28
    paragraphStyle.alignment = .center
    return label
  }()
  
  private func attributedText(text: String) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.28
    paragraphStyle.alignment = .center
    return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
  }
  
  var didRefresh: (() -> ())?
  
  required init(inView view: UIView, networkType: NetworkError) {
    super.init(frame: view.bounds)
    view.addSubview(self)
    setupLayout()
    setupText(networkType: networkType)
    showAlert()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func refreshAction() {
    removeFromSuperview()
    didRefresh?()
  }
  
  private func setupText(networkType: NetworkError) {
    switch networkType {
    case .noInternet:
      titleLabel.text = Constants.NoInternet.title.rawValue
      let text = Constants.NoInternet.description.rawValue
      descriptionLabel.attributedText = attributedText(text: text)
    case .serverResponse:
      titleLabel.text = Constants.SomethingWentWrong.title.rawValue
      let text = Constants.SomethingWentWrong.description.rawValue
      descriptionLabel.attributedText = attributedText(text: text)
    }
  }
  
  private func showAlert() {
    backgroundColor = .white
    titleLabel.isHidden = false
    descriptionLabel.isHidden = false
    refreshButton.isHidden = false
  }
  
  private func setupLayout() {
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    addSubview(refreshButton)
    refreshButton.snp.makeConstraints { (make) in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
      make.leading.trailing.equalTo(descriptionLabel)
      make.height.equalTo(44)
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
      make.leading.trailing.equalTo(descriptionLabel)
    }
    
    refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
  }
}


