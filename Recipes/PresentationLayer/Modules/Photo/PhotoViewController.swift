import UIKit
import SnapKit

final class PhotoViewController: UIViewController {
  
  // MARK: Properties
  var viewModel: PhotoViewModelProtocol?
  
  private let imageView = UIImageView()
  private let saveButton = UIButton(type: .system)
  private let closeButton = UIButton(type: .close)
  
  // MARK: Life Cycle
  init(image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    self.imageView.image = image
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
  
  // MARK: Private Methods
  @objc
  private func closeAction() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func saveAction() {
    guard let image = imageView.image else { return }
    viewModel?.save(photo: image) { [weak self] error in
      DispatchQueue.main.async {
        self?.alert(error: error)
      }
    }
  }
  
  // MARK: Layout
  private func alert(error: Error?) {
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
  
  private func setupLayout() {
    setupImageView()
    setupSaveButton()
    
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.centerY.centerX.equalToSuperview()
      make.height.lessThanOrEqualToSuperview().inset(200)
    }
    
    view.addSubview(saveButton)
    saveButton.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(32)
      make.top.equalTo(imageView.snp.bottom).offset(50)
      make.height.equalTo(44)
    }
    
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(50)
      make.top.equalToSuperview().inset(100)
      make.height.width.equalTo(40)
    }
  }
  
  private func setupImageView() {
    imageView.contentMode = .scaleAspectFit
  }
  
  private func setupSaveButton() {
    saveButton.setTitle("Download", for: .normal)
    saveButton.setTitleColor(.basic3, for: .normal)
    saveButton.layer.cornerRadius = 22
    saveButton.layer.borderWidth = 1
    saveButton.layer.borderColor = UIColor.basic3.cgColor
  }
}
  
  
