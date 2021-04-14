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
    title = "Recipes"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
    setupLayout()
    viewModel?.fetchData()
    didUpdateViewModel()
  }
  
  func didUpdateViewModel() {
    self.viewModel?.didUpdateViewModel = { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
}

// MARK: Data Source
extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel?.filteredRecipes.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifire, for: indexPath) as? RecipeTableViewCell else {
      return UITableViewCell()
    }
    if let recipe = viewModel?.filteredRecipes[indexPath.row] {
      cell.configure(with: recipe)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    112 + 26
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    viewModel?.didSelect(index: indexPath.row)
  }
  
}

// MARK: Search Results Updating
extension RecipesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel?.updateSearchResults(searchController: searchController)
  }
}

private extension RecipesViewController {
  
  func createActionSheet() {
    let actionSheet = UIAlertController()
    
    actionSheet.addAction(UIAlertAction(title: "Sort by Name", style: .default, handler: { _ in
      self.viewModel?.sort(type: .name)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Sort by Date", style: .default, handler: { _ in
      self.viewModel?.sort(type: .date)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(actionSheet, animated: true)
  }
  
  func setupLayout() {
    setupButton()
    setupSearchController()
    setupTableView()
  }
  
  func setupButton() {
    let button = UIBarButtonItem(title: "Sort by", style: .plain, target: self, action: #selector(showActionCheet))
    self.navigationItem.rightBarButtonItem = button
  }
  
  @objc func showActionCheet() {
    createActionSheet()
  }
  
  func setupSearchController() {
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = self.searchController
    searchController.searchResultsUpdater = self
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

