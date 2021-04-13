import UIKit
import SnapKit

final class DetailViewController: UIViewController {
  
  
  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    return scroll
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  private lazy var photoScrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.isPagingEnabled = true
    scroll.showsHorizontalScrollIndicator = false
    return scroll
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .boldSystemFont(ofSize: 28)
    label.numberOfLines = 2
    label.text = "Caramelized French Onion Dip"
    return label
  }()

  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 0
    label.text = "Yummy home made meat loaf, great for left lovers."
    return label
  }()
  
  private lazy var difficultyTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    label.text = "Difficulty:"
    return label
  }()
  
  private lazy var instructionTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    label.text = "Instruction:"
    return label
  }()
  
  private lazy var recommendedTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    label.text = "Recommended:"
    return label
  }()
  
  private lazy var instructionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.text = "Mix thyme, cayenne, nutmeg, Panko bread crumbs, salt, and pepper into a small bowl, set aside. Mix eggs, minced garlic, minced or chopped onion, and 1/4 cup BBQ sauce in a medium bowl. \n \nBreak up ground beef so its not blocked or clumped, mix in the egg mixture until evenly distributed throughout then add bread crumb mixture until evenly distributed. Put into loaf pan."
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 1
    label.textAlignment = .right
    label.text = "01.05.2018"
    return label
  }()
  
  private lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl(frame: .zero)
    pageControl.isEnabled = false
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.numberOfPages = 4
    return pageControl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    sutupLayout()
  }
}



extension DetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = Int(scrollView.contentOffset.x / photoScrollView.frame.width)
    self.pageControl.currentPage = position
  }
}


private extension DetailViewController {
  
  func sutupLayout() {
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(photoScrollView)
    contentView.addSubview(pageControl)
    contentView.addSubview(titleLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(difficultyTitleLabel)
    contentView.addSubview(instructionTitleLabel)
    contentView.addSubview(recommendedTitleLabel)
    contentView.addSubview(instructionLabel)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view).inset(UIEdgeInsets.zero)
    }
    
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
    
    photoScrollView.backgroundColor = .systemBlue
    photoScrollView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(300)
    }
    
    pageControl.snp.makeConstraints { (make) in
      make.bottom.equalTo(photoScrollView)
      make.centerX.equalTo(contentView)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(photoScrollView.snp.bottom).offset(20)
      make.leading.equalTo(contentView).inset(20)
      make.trailing.equalTo(dateLabel.snp.leading)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.bottom.equalTo(titleLabel)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    difficultyTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    instructionTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(difficultyTitleLabel.snp.bottom).offset(44)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    instructionLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionTitleLabel.snp.bottom).offset(8)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    recommendedTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionLabel.snp.bottom).offset(15)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    for i in 0..<5 {
      let difficultyImageView = UIImageView()
      contentView.addSubview(difficultyImageView)
      if i < 3 {
        difficultyImageView.image = UIImage(named: "shape1")
      } else {
        difficultyImageView.image = UIImage(named: "shape0")
      }
      difficultyImageView.snp.makeConstraints { (make) in
        make.top.equalTo(difficultyTitleLabel.snp.bottom).offset(8)
        make.width.height.equalTo(20)
        make.leading.equalTo(40 * i + 24)
      }
    }
    
    contentView.snp.makeConstraints({ (make) in
      make.bottom.equalTo(recommendedTitleLabel.snp.bottom)
    })
    
    
  }
  
}

