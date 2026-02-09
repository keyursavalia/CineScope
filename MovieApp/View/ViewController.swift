import UIKit

final class ViewController: UIViewController {
    
    private let movieDetailView = MovieDetailView()
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
        view.backgroundColor = .systemBackground
        view.addSubview(movieDetailView)
        movieDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        movieDetailView.searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            movieDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            movieDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onMediaUpdated = { [weak self] model in
            self?.movieDetailView.update(with: model)
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(message: errorMessage)
        }
        
        viewModel.onLoadingChanged = { isLoading in
            // You can add loading indicator here
            print("Loading: \(isLoading)")
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        viewModel.searchMulti(query: searchText)
    }
}
