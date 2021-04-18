import UIKit
import SnapKit

final class DetailRecipeViewController: UIViewController {
  
  var viewModel: DetailRecipeViewModel?
  var recipeRecommendedViewController = RecipeRecommendedViewController()
  
  lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    return scroll
  }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var photoScrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.isPagingEnabled = true
    scroll.showsHorizontalScrollIndicator = false
    scroll.delegate = self
    return scroll
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .boldSystemFont(ofSize: 28)
    label.numberOfLines = 0
    return label
  }()
  
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 0
    return label
  }()
  
  lazy var difficultyTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    return label
  }()
  
  lazy var instructionTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    return label
  }()
  
  lazy var recommendedTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 18)
    label.numberOfLines = 1
    return label
  }()
  
  lazy var instructionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor(red: 0.611, green: 0.611, blue: 0.611, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    return label
  }()
  
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
    label.font = .systemFont(ofSize: 13)
    label.numberOfLines = 1
    label.textAlignment = .right
    return label
  }()
  
  lazy var pageControl: UIPageControl = {
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
    viewModel?.fetchData()
  }
  
}

// MARK: UIScrollViewDelegate
extension DetailRecipeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = Int(scrollView.contentOffset.x / photoScrollView.frame.width)
    pageControl.currentPage = position
  }
}

// MARK: View Model Data Binding
private extension DetailRecipeViewController {
  
  func didUpdateViewModel() {
    showRecipe()
    didFetchData()
    didError()
  }
  
  func showRecipe() {
    recipeRecommendedViewController.didSelect = { id in
      self.viewModel?.showRecipe(id: id)
    }
  }
  
  func didFetchData() {
    viewModel?.didFetchData = { [weak self] recipe in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.difficultyTitleLabel.text = "Difficulty:"
        self.instructionLabel.text = "Instruction:"
        self.recommendedTitleLabel.text = "Recommended:"
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
          self.recipeRecommendedViewController.reloadData()
        }
      }
    }
  }
  
  func didError() {
    var hud: HudView?
    viewModel?.didHud = { [weak self] type in
      guard let self = self else { return }
      DispatchQueue.main.async {
        if let h = hud {
          h.didClose = {
            hud = nil
          }
          h.didRefresh = {
            hud = nil
            self.viewModel?.fetchData()
          }
          h.action(type: type)
        } else {
          hud = HudView(inView: self.navigationController?.view ?? self.view, type: type)
        }
      }
    }
  }
  
}
