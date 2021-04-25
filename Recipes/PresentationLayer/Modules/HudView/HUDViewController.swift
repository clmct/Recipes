import UIKit
import SnapKit

final class NetworkErrorViewController: UIViewController {
  
  private let refreshButton = UIButton(type: .system)
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  
  var didRefresh: (() -> ())?
  
  convenience init(networkError: NetworkError) {
    self.init(nibName:nil, bundle:nil)
    setupText(networkType: networkError)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }

  @objc
  private func refreshAction() {
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
  
  private func setupLayout() {
    view.backgroundColor = .white
    setupRefreshButton()
    setupTitleLabel()
    setupDescriptionLabel()
    
    view.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    view.addSubview(refreshButton)
    refreshButton.snp.makeConstraints { (make) in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
      make.leading.trailing.equalTo(descriptionLabel)
      make.height.equalTo(44)
    }
    
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
      make.leading.trailing.equalTo(descriptionLabel)
    }
    
    refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
  }
  
  private func setupRefreshButton() {
    refreshButton.setTitle("Refresh", for: .normal)
    refreshButton.setTitleColor(.basic3, for: .normal)
    refreshButton.layer.cornerRadius = 22
    refreshButton.layer.borderWidth = 1
    refreshButton.layer.borderColor = UIColor.basic3.cgColor
  }
  
  private func setupTitleLabel() {
    titleLabel.numberOfLines = 0
    titleLabel.textColor = .basic5
    titleLabel.font = .basic6
    titleLabel.textAlignment = .center
  }
  
  private func setupDescriptionLabel() {
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = .basic5
    descriptionLabel.font = .basic5
    descriptionLabel.textAlignment = .center
  }
  
  private func attributedText(text: String) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.28
    paragraphStyle.alignment = .center
    return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
  }
}


protocol HudErrorShowing {}
extension HudErrorShowing where Self: UINavigationController {
  func showHudError(networkError: NetworkError,
                    completion: @escaping () -> ()) {
    
    let hudView = NetworkErrorViewController(networkError: .noInternet)
    hudView.didRefresh = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      completion()
    }
    hudView.modalPresentationStyle = .fullScreen
    present(hudView, animated: true, completion: nil)
  }
}

extension UINavigationController: HudErrorShowing {
  
}
