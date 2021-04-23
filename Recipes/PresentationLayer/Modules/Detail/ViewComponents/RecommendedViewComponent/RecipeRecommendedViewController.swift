import UIKit
import SnapKit

final class RecipeRecommendedViewController: UIViewController {
  
  // MARK: Properties
  private var recommendedTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .basic1
    label.font = .basic4
    label.numberOfLines = 1
    label.text = "Recommended:"
    return label
  }()
  
  private var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    let collectioView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectioView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    collectioView.showsHorizontalScrollIndicator = false
    return collectioView
  }()
  
  private var recipesBrief: [RecipeBrief]?
  var didSelect: ((String) -> ())?
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollection()
    setupLayout()
  }
  
  // MARK: Internal Methods
  func configure(recipesBrief: [RecipeBrief]) {
    self.recipesBrief = recipesBrief
    collectionView.reloadData()
  }
  
  // MARK: Private Methods
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
    recipesBrief?.count ?? 0
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
    CGSize(width: 204, height: 112)
  }
}
