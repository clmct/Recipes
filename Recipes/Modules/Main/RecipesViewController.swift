import UIKit
import SnapKit

final class RecipesViewController: UIViewController {
  
  var viewModel: RecipesViewModelProtocol?
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    return tableView
  }()
  
  lazy var searchController: UISearchController = {
    let searchController = UISearchController()
    searchController.searchBar.autocapitalizationType = .none
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.scopeButtonTitles = ["Name", "Description", "Instructions"]
    return searchController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    self.viewModel?.fetchData()
    fetchData()
  }
  
  func fetchData() {
    self.viewModel?.didFetchData = { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
  }
  
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel?.recipes.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifire, for: indexPath) as? RecipeTableViewCell else {
      return UITableViewCell()
    }
    if let recipe = viewModel?.recipes[indexPath.row] {
      cell.configure(with: recipe)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    112 + 26
  }
  
}

private extension RecipesViewController {
  
  func setupLayout() {
    setupButton()
    setupSearchController()
    setupTableView()
  }
  
  func setupButton() {
    let button = UIBarButtonItem(title: "Sort by", style: .plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = button
  }
  
  func setupSearchController() {
    title = "Recipes"
    navigationController?.navigationBar.prefersLargeTitles = true
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = self.searchController
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifire)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
}
