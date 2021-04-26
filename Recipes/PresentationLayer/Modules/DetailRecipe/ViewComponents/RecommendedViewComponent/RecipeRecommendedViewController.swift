import UIKit
import SnapKit

final class RecipeRecommendedViewController: UIViewController {
  
  // MARK: Properties
  private let recommendedTitleLabel = UILabel()
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  
  private var recipesBrief: [RecipeBrief]?
  var didSelect: ((String) -> ())?
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRecommendedTitleLabel()
    setupCollectionView()
    setupCollection()
    setupLayout()
  }
  
  // MARK: Internal Methods
  func configure(recipesBrief: [RecipeBrief]) {
    self.recipesBrief = recipesBrief
    collectionView.reloadData()
  }
  
  // MARK: Private Methods
  
  private func setupRecommendedTitleLabel() {
    recommendedTitleLabel.textColor = .basic1
    recommendedTitleLabel.font = .basic4
    recommendedTitleLabel.numberOfLines = 1
    recommendedTitleLabel.text = "Recommended:"
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    collectionView.collectionViewLayout = layout
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    collectionView.showsHorizontalScrollIndicator = false
  }
  
  private func setupCollection() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(RecipeRecommendedCollectionViewCell.self,
                            forCellWithReuseIdentifier: RecipeRecommendedCollectionViewCell.identifier)
  }
  
  private func setupLayout() {
    view.addSubview(recommendedTitleLabel)
    recommendedTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top).offset(8)
      make.leading.equalTo(view).inset(24)
      make.trailing.equalTo(view).inset(24)
    }
    
    view.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(recommendedTitleLabel.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    view.snp.makeConstraints { (make) in
      make.bottom.equalTo(collectionView.snp.bottom).offset(15)
    }
  }
}

// MARK: Data Source && Delegate
extension RecipeRecommendedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipesBrief?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeRecommendedCollectionViewCell.identifier, for: indexPath) as? RecipeRecommendedCollectionViewCell else {
      return UICollectionViewCell()
    }
    if let recipe = recipesBrief {
      cell.configure(with: recipe[indexPath.row])
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let recipes = recipesBrief {
      let id = recipes[indexPath.row].uuid
      didSelect?(id)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 204, height: 112)
  }
}
