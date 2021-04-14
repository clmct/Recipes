import UIKit
import SnapKit

final class DetailRecipeViewController: UIViewController {
  
  var viewModel: DetailRecipeViewModel?
  var recipeRecommendedViewController = RecipeRecommendedViewController()
  
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
    scroll.delegate = self
    return scroll
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .boldSystemFont(ofSize: 28)
    label.numberOfLines = 0
    return label
  }()

  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 0
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
    return pageControl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .white
    sutupLayout()
    didUpdateViewModel()
    showRecipe()
  }
  
  func showRecipe() {
    recipeRecommendedViewController.didSelect = { id in
      self.viewModel?.showRecipe(id: id)
    }
  }
  
  func didUpdateViewModel() {
    viewModel?.didFetchData = { [weak self] recipe in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.titleLabel.text = recipe.name
        self.descriptionLabel.text = recipe.description
        self.instructionLabel.text = recipe.instructions.replace()
        self.dateLabel.text = recipe.lastUpdated.getDate()
        self.setupDifficulty(difficulty: recipe.difficulty)
        self.setupPhotosScroll(count: recipe.images.count)
        if recipe.images.count <= 1 {
          self.pageControl.isHidden = true
        }
        if recipe.similar.count != 0 {
          self.setupRecommended()
          self.recipeRecommendedViewController.recipesBrief = recipe.similar
          self.recipeRecommendedViewController.didUpdate()
        }
      }
    }
  }
  
  
  
  func setupRecommended() {
    
    contentView.addSubview(recommendedTitleLabel)
    addChild(recipeRecommendedViewController)
    contentView.addSubview(recipeRecommendedViewController.view)
    recipeRecommendedViewController.didMove(toParent: self)
    
    
    recommendedTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(instructionLabel.snp.bottom).offset(15)
      make.leading.equalTo(contentView).inset(24)
      make.trailing.equalTo(contentView).inset(24)
    }
    
    recipeRecommendedViewController.view.snp.makeConstraints { make in
      make.top.equalTo(recommendedTitleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalTo(contentView)
      make.height.equalTo(112)
    }

    contentView.snp.remakeConstraints { (make) in
      make.edges.width.equalToSuperview()
      make.bottom.equalTo(recipeRecommendedViewController.view.snp.bottom)
    }
    contentView.layoutIfNeeded()
    scrollView.layoutIfNeeded()
    
  }
  
  func setupDifficulty(difficulty: Int) {
    for i in 0..<5 {
      let difficultyImageView = UIImageView()
      contentView.addSubview(difficultyImageView)
      if i < difficulty {
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
  }
  
  func setupPhotosScroll(count: Int) {
    for i in 0..<count {
      let imageView = UIImageView()
      if let url = URL(string: (self.viewModel?.recipe?.images[i])!) {
        imageView.kf.setImage(with: url)
      }
      imageView.contentMode = .scaleAspectFill
      let xPosition = self.photoScrollView.frame.width * CGFloat(i)
      imageView.frame = CGRect(x: xPosition, y: 0,
                               width: self.photoScrollView.frame.width,
                               height: self.photoScrollView.frame.height)
      
      photoScrollView.contentSize.width =  photoScrollView.frame.width * CGFloat(1 + i)
      photoScrollView.addSubview(imageView)
      pageControl.numberOfPages = count
    }
  }
}

extension DetailRecipeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = Int(scrollView.contentOffset.x / photoScrollView.frame.width)
    pageControl.currentPage = position
  }
}

private extension DetailRecipeViewController {
  
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
    contentView.addSubview(instructionLabel)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
    
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
      make.trailing.equalTo(contentView).inset(70 + 24)
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
    
    contentView.snp.makeConstraints({ (make) in
      make.bottom.equalTo(instructionLabel.snp.bottom)
    })
    
  }
  
}

