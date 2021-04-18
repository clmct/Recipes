import UIKit
import SnapKit

final class PhotoViewController: UIViewController {
  
  var viewModel: PhotoViewModelProtocol?
  
  private lazy var imgView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  private lazy var saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Download", for: .normal)
    button.setTitleColor(UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1), for: .normal)
    button.layer.cornerRadius = 22
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(red: 0.29, green: 0.565, blue: 0.886, alpha: 1).cgColor
    
    return button
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .close)
    return button
  }()
  
  init(image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    self.imgView.image = image
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    setupLayout()
    saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
  }
  
  @objc func closeAction() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func saveAction() {
    guard let image = imgView.image else { return }
    viewModel?.save(photo: image) { [weak self] (_, error) in
      DispatchQueue.main.async {
        self?.alert(error: error)
      }
    }
  }
  
  func alert(error: Error?) {
    if let error = error {
      let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "Saved", message: "", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  func setupLayout() {
    
    view.addSubview(imgView)
    imgView.snp.makeConstraints { (make) in
      make.centerY.centerX.equalToSuperview()
      make.height.lessThanOrEqualToSuperview().inset(200)
    }
    
    view.addSubview(saveButton)
    saveButton.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(32)
      make.top.equalTo(imgView.snp.bottom).offset(50)
      make.height.equalTo(44)
    }
    
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(50)
      make.top.equalToSuperview().inset(100)
      make.height.width.equalTo(40)
    }

  }
}
  
  
