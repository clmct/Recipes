import UIKit
import SnapKit

final class DetailRecipeViewController: UIViewController {
  
  var viewModel: DetailRecipeViewModelProtocol?
  
  private let loader = UIActivityIndicatorView(style: .medium)
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private var photosViewComponent = PhotosViewComponent()
  private var informationViewComponent = InformationViewComponent()
  private var recipeRecommendedViewController = RecipeRecommendedViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sutupLayout()
    bindUpdateViewModel()
    viewModel?.fetchData()
  }
  
  // MARK: ViewModelBinding
  private func bindUpdateViewModel() {
    showRecipe()
    fetchData()
    showErrorHUD()
    showLoader()
    showPhoto()
  }
  
  private func showPhoto() {
    photosViewComponent.didTapPhoto = { [weak self] image in
      guard let self = self else { return }
      self.viewModel?.showPhoto(image: image)
    }
  }
  
  private func showRecipe() {
    recipeRecommendedViewController.didSelect = { [weak self] id in
      guard let self = self else { return }
      self.viewModel?.showRecipe(id: id)
    }
  }
  
  private func fetchData() {
    viewModel?.didFetchData = { [weak self] recipe in
      guard let self = self else { return }
      self.informationViewComponent.configure(recipe: recipe)
      
      self.photosViewComponent.configure(images: recipe.images)
      if recipe.images.count <= 1 {
        self.photosViewComponent.hidePageControl()
      }
      
      if recipe.similar.count != 0 {
        self.setupRecommendedComponent()
        self.recipeRecommendedViewController.configure(recipesBrief: recipe.similar)
      }
    }
  }
  
  private func showErrorHUD() {
    viewModel?.didRequestShowHUD = { [weak self] error in
      guard let self = self else { return }
      var hudView: HudView? = HudView(inView: self.view, networkType: error)
      hudView?.didRefresh = {
        hudView = nil
        self.viewModel?.fetchData()
      }
    }
  }
  
  private func showLoader() {
    viewModel?.didRequestLoader = { [weak self] action in
      guard let self = self else { return }
      switch action {
      case .start:
        self.loader.startAnimating()
      case .stop:
        self.loader.stopAnimating()
      }
    }
  }
  
  // MARK: Layout
  private func sutupLayout() {
    setupNavigationItem()
    setupBasicLayout()
    setupPhotosComponent()
    setupInformationComponent()
    setupLoader()
  }
  
  private func setupNavigationItem() {
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .white
  }
  
  private func setupLoader() {
    view.addSubview(loader)
    view.bringSubviewToFront(loader)
    loader.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  private func setupBasicLayout() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
  }
  
  private func setupRecommendedComponent() {
    addChild(recipeRecommendedViewController)
    contentView.addSubview(recipeRecommendedViewController.view)
    recipeRecommendedViewController.didMove(toParent: self)
    
    recipeRecommendedViewController.view.snp.makeConstraints { make in
      make.top.equalTo(informationViewComponent.snp.bottom).offset(8)
      make.leading.trailing.equalTo(contentView)
      make.height.equalTo(112 + 50)
    }
    
    contentView.snp.remakeConstraints { (make) in
      make.edges.width.equalToSuperview()
      make.bottom.equalTo(recipeRecommendedViewController.view.snp.bottom)
    }
  }
  
  private func setupPhotosComponent() {
    contentView.addSubview(photosViewComponent)
    photosViewComponent.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
    }
  }
  
  private func setupInformationComponent() {
    contentView.addSubview(informationViewComponent)
    informationViewComponent.snp.makeConstraints { (make) in
      make.top.equalTo(photosViewComponent.snp.bottom)
      make.leading.trailing.equalTo(contentView)
    }
    contentView.snp.makeConstraints({ (make) in
      make.bottom.equalTo(informationViewComponent.snp.bottom)
    })
  }
}
