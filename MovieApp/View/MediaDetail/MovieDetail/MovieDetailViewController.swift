import UIKit

final class MovieDetailViewController: UIViewController {
    private let searchBarView = SearchBarView()
    private let movieDetailView = MovieDetailView()
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
        view.addSubview(movieDetailView)
        view.addSubview(searchBarView)
        movieDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarView.delegate = self
        movieDetailView.delegate = self
        movieDetailView.imageService = ImageService()
        movieDetailView.internalScrollView.delegate = self
        
        searchBarTopConstraint = searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            searchBarTopConstraint,
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: searchBarHeight),
            
            movieDetailView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            movieDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadDetail() {
        Task {
            let model = await viewModel.buildMovieDisplayModel(for: mediaItem)
            movieDetailView.update(with: model)
            
            // Load cast and gallery
            if let movieId = mediaItem.id {
                let cast = await viewModel.fetchCastDisplayItems(mediaType: "movie", id: movieId)
                movieDetailView.updateCast(with: cast)
                
                let gallery = await viewModel.fetchGalleryURLs(mediaType: "movie", id: movieId)
                movieDetailView.updateGallery(with: gallery)
            }
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
extension MovieDetailViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didSearchFor query: String) {
        navigationController?.popViewController(animated: true)
        if let searchVC = navigationController?.topViewController as? SearchResultsViewController {
            searchVC.performSearch(query: query)
        }
    }
}

// MARK: - MovieDetailViewDelegate
extension MovieDetailViewController: MovieDetailViewDelegate {
    func movieDetailView(_ view: MovieDetailView, didSelectCastMemberWithId id: Int) {
        let castItem = MediaItem(
            id: id,
            title: nil,
            name: nil,
            mediaType: "person",
            overview: nil,
            posterPath: nil,
            profilePath: nil,
            voteAverage: nil,
            genreIds: nil,
            knownForDepartment: nil,
            releaseDate: nil,
            firstAirDate: nil
        )
        let personVC = PersonDetailViewController(mediaItem: castItem, viewModel: viewModel)
        navigationController?.pushViewController(personVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate (scroll-to-hide search bar)
extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let delta = currentOffset - lastScrollOffset
        
        // Always show search bar when at the top
        if currentOffset <= 0 {
            if !isSearchBarVisible {
                setSearchBarHidden(false, animated: true)
                lastScrollOffset = currentOffset
            }
            return
        }
        
        // Use a meaningful threshold to avoid jitter
        let threshold: CGFloat = 15
        
        // Hide when scrolling down
        if delta > threshold && isSearchBarVisible {
            setSearchBarHidden(true, animated: true)
            lastScrollOffset = currentOffset
        }
        // Show when scrolling up
        else if delta < -threshold && !isSearchBarVisible {
            setSearchBarHidden(false, animated: true)
            lastScrollOffset = currentOffset
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Capture the offset when user starts dragging to ensure stable comparison
        lastScrollOffset = scrollView.contentOffset.y
    }
}
