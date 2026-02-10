import UIKit

final class SearchResultsViewController: UIViewController {
    
    private let searchBarView = SearchBarView()
    private let searchResultsView = SearchResultsView()
    private var searchResults: [MediaItem] = []
    private let imageService: ImageServiceProtocol = ImageService()
    private let viewModel: MediaViewModel
    
    // Dependency injection for testability
    init(viewModel: MediaViewModel = MediaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MediaViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        title = "CineScope"
        view.backgroundColor = .systemBackground
        view.addSubview(searchBarView)
        view.addSubview(searchResultsView)
        searchResultsView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarView.delegate = self
        searchResultsView.tableView.dataSource = self
        searchResultsView.tableView.delegate = self
        searchResultsView.tableView.keyboardDismissMode = .onDrag
        
        NSLayoutConstraint.activate([
            
            // Search Bar
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Search Results (TableView)
            searchResultsView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            searchResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onSearchResultsUpdated = { [weak self] items in
            self?.searchResults = items
            self?.searchResultsView.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(message: errorMessage)
        }
        
        viewModel.onLoadingChanged = { isLoading in
            // You can add loading indicator here
            print("Loading: \(isLoading)")
        }
    }
    
    func performSearch(query: String) {
        searchBarView.setSearchText(query)
        viewModel.searchMulti(query: query)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didSearchFor query: String) {
        viewModel.searchMulti(query: query)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let item = searchResults[indexPath.row]
        cell.configure(with: item)
        cell.loadImage(from: item, using: imageService)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBarView.resignSearchBar()
        let selectedItem = searchResults[indexPath.row]
        
        let detailVC: UIViewController
        switch selectedItem.mediaType {
        case "movie":
            detailVC = MovieDetailViewController(mediaItem: selectedItem, viewModel: viewModel)
        case "tv":
            detailVC = SeriesDetailViewController(mediaItem: selectedItem, viewModel: viewModel)
        case "person":
            detailVC = PersonDetailViewController(mediaItem: selectedItem, viewModel: viewModel)
        default:
            return
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
