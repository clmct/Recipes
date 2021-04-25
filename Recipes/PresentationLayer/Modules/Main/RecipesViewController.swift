import UIKit
import SnapKit

final class RecipesViewController: UIViewController {
  
  // MARK: Properties
  var viewModel: RecipesViewModelProtocol?
  private let loader = UIActivityIndicatorView(style: .medium)
  private let tableView = UITableView()
  private  let searchController = UISearchController()
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    bindToViewModel()
    viewModel?.fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.deselectSelectedRow(animated: animated)
  }
  
  // MARK: BindToViewModel
  private func bindToViewModel() {
    viewModel?.didUpdateViewModel = { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
  
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
  
  // MARK: Private Methods
  @objc
  private func showActionCheet() {
    createActionSheet()
  }
  
  // MARK: Layout
  private func createActionSheet() {
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
  
  private func setupLayout() {
    setupNavigationItem()
    setupButton()
    setupSearchController()
    setupTableView()
    setupLoader()
  }
  
  private func setupNavigationItem() {
    title = "Recipes"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    navigationItem.largeTitleDisplayMode = .always
  }
  
  private func setupLoader() {
    view.addSubview(loader)
    view.bringSubviewToFront(loader)
    loader.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  private func setupButton() {
    let button = UIBarButtonItem(title: "Sort by", style: .plain, target: self, action: #selector(showActionCheet))
    self.navigationItem.rightBarButtonItem = button
  }
  
  private func setupSearchController() {
    searchController.searchBar.autocapitalizationType = .none
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.scopeButtonTitles = [
      Constants.Filter.nameFilterIndex.rawValue,
      Constants.Filter.descriptionFilterIndex.rawValue,
      Constants.Filter.instructionFilterIndex.rawValue]
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = self.searchController
    searchController.searchResultsUpdater = self
  }
  
  private func setupTableView() {
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

// MARK: Data Source && Delegate
extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.filteredRecipes.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as? RecipeTableViewCell else {
      return UITableViewCell()
    }
    if let recipe = viewModel?.filteredRecipes[indexPath.row] {
      cell.configure(with: recipe)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 138
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.select(index: indexPath.row)
  }
}

// MARK: UISearchResultsUpdating
extension RecipesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    let index = searchController.searchBar.selectedScopeButtonIndex
    viewModel?.updateSearchResults(text: text, index: index)
  }
}

extension RecipesViewController: HudErrorShowing {
  
}
