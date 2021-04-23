import UIKit
import SnapKit

final class PhotosViewComponent: UIView {
  
  // MARK: Properties
  private lazy var photoScrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.isPagingEnabled = true
    scroll.showsHorizontalScrollIndicator = false
    scroll.delegate = self
    return scroll
  }()
  
  private var pageControl: UIPageControl = {
    let pageControl = UIPageControl(frame: .zero)
    pageControl.isEnabled = false
    return pageControl
  }()
  
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
      let xPosition = photoScrollView.frame.width * CGFloat(i)
      imageView.frame = CGRect(x: xPosition, y: 0,
                               width: photoScrollView.frame.width,
                               height: photoScrollView.frame.height)
      
      photoScrollView.contentSize.width = photoScrollView.frame.width * CGFloat(1 + i)
      photoScrollView.addSubview(imageView)
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
    addSubview(photoScrollView)
    photoScrollView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
      make.height.equalTo(300)
    }
    
    addSubview(pageControl)
    pageControl.snp.makeConstraints { (make) in
      make.bottom.equalTo(self)
      make.centerX.equalTo(self)
    }
    
    self.snp.makeConstraints { (make) in
      make.bottom.equalTo(photoScrollView.snp.bottom)
    }
  }
}

// MARK: UIScrollViewDelegate
extension PhotosViewComponent: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = Int(scrollView.contentOffset.x / photoScrollView.frame.width)
    pageControl.currentPage = position
  }
}
