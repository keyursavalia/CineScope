import UIKit

final class PersonDetailViewController: UIViewController {
    private let searchBarView = SearchBarView()
    private let personDetailView = PersonDetailView()
    private let mediaItem: MediaItem
    private let viewModel: MediaViewModel
    
    init(mediaItem: MediaItem, viewModel: MediaViewModel) {
        self.mediaItem = mediaItem
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mediaItem.displayName
        setupView()
        loadDetail()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBarView)
        view.addSubview(personDetailView)
        personDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarView.delegate = self
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            personDetailView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            personDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadDetail() {
        Task {
            let model = await viewModel.buildPersonDisplayModel(for: mediaItem)
            personDetailView.update(with: model)
        }
    }
}

// MARK: - SearchBarViewDelegate
extension PersonDetailViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didSearchFor query: String) {
        navigationController?.popViewController(animated: true)
        if let searchVC = navigationController?.topViewController as? SearchResultsViewController {
            searchVC.performSearch(query: query)
        }
    }
}
