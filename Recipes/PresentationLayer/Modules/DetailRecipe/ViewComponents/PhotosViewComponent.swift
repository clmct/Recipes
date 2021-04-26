import UIKit
import SnapKit

final class PhotosViewComponent: UIView {
  
  // MARK: Properties  
  private let photosScrollView = UIScrollView()
  private let pageControl = UIPageControl(frame: .zero)
  var didTapPhoto: ((UIImage) -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal Methods
  func hidePageControl() {
    pageControl.isHidden = true
  }
  
  func configure(images: [String]) {
    for i in 0..<images.count {
      let imageView = UIImageView()
      guard let url = URL(string: (images[i])) else { return }
      imageView.kf.setImage(with: url)
      let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tapGestureRecognizer:)))
      imageView.addGestureRecognizer(tap)
      imageView.isUserInteractionEnabled = true
      imageView.contentMode = .scaleAspectFill
      let xPosition = photosScrollView.frame.width * CGFloat(i)
      imageView.frame = CGRect(x: xPosition, y: 0,
                               width: photosScrollView.frame.width,
                               height: photosScrollView.frame.height)
      
      photosScrollView.contentSize.width = photosScrollView.frame.width * CGFloat(1 + i)
      photosScrollView.addSubview(imageView)
      pageControl.numberOfPages = images.count
      
    }
  }
  
  // MARK: Private Methods
  @objc
  private func tapAction(tapGestureRecognizer: UITapGestureRecognizer) {
    guard let tappedImage = tapGestureRecognizer.view as? UIImageView else { return }
    if let image = tappedImage.image {
      didTapPhoto?(image)
    }
  }
  
  private func setupLayout() {
    setupPhotosScrollView()
    setupPageControl()
    
    addSubview(photosScrollView)
    photosScrollView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
      make.height.equalTo(300)
    }
    
    addSubview(pageControl)
    pageControl.snp.makeConstraints { (make) in
      make.bottom.equalTo(self)
      make.centerX.equalTo(self)
    }
    
    self.snp.makeConstraints { (make) in
      make.bottom.equalTo(photosScrollView.snp.bottom)
    }
  }
  
  private func setupPhotosScrollView() {
    photosScrollView.isPagingEnabled = true
    photosScrollView.showsHorizontalScrollIndicator = false
    photosScrollView.delegate = self
  }
  
  private func setupPageControl() {
    pageControl.isEnabled = false
  }
}

// MARK: UIScrollViewDelegate
extension PhotosViewComponent: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = Int(scrollView.contentOffset.x / photosScrollView.frame.width)
    pageControl.currentPage = position
  }
}

