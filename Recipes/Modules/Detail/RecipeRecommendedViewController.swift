import UIKit
import SnapKit

final class RecipeRecommendedViewController: UIViewController {
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    let collectioView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectioView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    collectioView.showsHorizontalScrollIndicator = false
    return collectioView
  }()
  
  var recipesBrief: [RecipeBrief]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupLayout()
  }
  
  func didUpdate() {
    collectionView.reloadData()
  }
  
  func setupCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(RecipeRecommendedCollectionViewCell.self,
                            forCellWithReuseIdentifier: RecipeRecommendedCollectionViewCell.identifire)
  }
  
  func setupLayout() {
    view.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  var didSelect: ((String) -> ())?
  
}


extension RecipeRecommendedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    recipesBrief?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeRecommendedCollectionViewCell.identifire, for: indexPath) as? RecipeRecommendedCollectionViewCell else {
      return UICollectionViewCell()
    }
    if let recipe = recipesBrief {
      cell.configure(with: recipe[indexPath.row])
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let id = recipesBrief![indexPath.row].uuid
    didSelect?(id)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: 204, height: 112)
  }
  
  
}
