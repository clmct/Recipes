import UIKit
import SnapKit

final class HudView: UIView {
  
  private var refreshButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Refresh", for: .normal)
    button.setTitleColor(UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1), for: .normal)
    button.layer.cornerRadius = 22
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1).cgColor
    return button
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor(red: 0.213, green: 0.213, blue: 0.213, alpha: 1)
    label.font = .boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    return label
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor(red: 0.213, green: 0.213, blue: 0.213, alpha: 1)
    label.font = .systemFont(ofSize: 16)
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
      titleLabel.text = "No internet"
      let text = "Try refreshing the screen when communication is restored."
      descriptionLabel.attributedText = attributedText(text: text)
    case .serverResponse:
      titleLabel.text = "Something went wrong"
      let text = "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
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


