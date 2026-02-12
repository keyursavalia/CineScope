import UIKit

final class PersonDetailViewController: UIViewController {
    private let searchBarView = SearchBarView()
    private let personDetailView = PersonDetailView()
    private let mediaItem: MediaItem
    private let viewModel: MediaViewModel
    
    private var searchBarTopConstraint: NSLayoutConstraint!
    private var lastScrollOffset: CGFloat = 0
    private let searchBarHeight: CGFloat = 56
    private var isSearchBarVisible = true
    
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
        view.addSubview(personDetailView)
        view.addSubview(searchBarView)
        personDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarView.delegate = self
        personDetailView.internalScrollView.delegate = self
        
        searchBarTopConstraint = searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            searchBarTopConstraint,
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: searchBarHeight),
            
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
            title = model.name
        }
    }
    
    private func setSearchBarHidden(_ hidden: Bool, animated: Bool) {
        guard hidden != !isSearchBarVisible else { return }
        isSearchBarVisible = !hidden
        
        let offset: CGFloat = hidden ? -(searchBarHeight + view.safeAreaInsets.top) : 0
        searchBarTopConstraint.constant = offset
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.view.layoutIfNeeded()
                self.searchBarView.alpha = hidden ? 0 : 1
            }
        } else {
            searchBarView.alpha = hidden ? 0 : 1
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

// MARK: - UIScrollViewDelegate (scroll-to-hide search bar)
extension PersonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let delta = currentOffset - lastScrollOffset
        
        if currentOffset <= 0 {
            setSearchBarHidden(false, animated: true)
        } else if delta > 6 {
            setSearchBarHidden(true, animated: true)
        } else if delta < -6 {
            setSearchBarHidden(false, animated: true)
        }
        
        lastScrollOffset = currentOffset
    }
}
