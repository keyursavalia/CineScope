import UIKit

final class SeriesDetailViewController: UIViewController {
    private let searchBarView = SearchBarView()
    private let seriesDetailView = SeriesDetailView()
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
        view.addSubview(seriesDetailView)
        view.addSubview(searchBarView)
        seriesDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarView.delegate = self
        seriesDetailView.delegate = self
        seriesDetailView.internalScrollView.delegate = self
        
        searchBarTopConstraint = searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            searchBarTopConstraint,
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: searchBarHeight),
            
            seriesDetailView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            seriesDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seriesDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seriesDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadDetail() {
        Task {
            let model = await viewModel.buildSeriesDisplayModel(for: mediaItem)
            seriesDetailView.update(with: model)
            
            // Load cast
            if let seriesId = mediaItem.id {
                let cast = await viewModel.fetchCastDisplayItems(mediaType: "tv", id: seriesId)
                seriesDetailView.updateCast(with: cast)
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
extension SeriesDetailViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didSearchFor query: String) {
        navigationController?.popViewController(animated: true)
        if let searchVC = navigationController?.topViewController as? SearchResultsViewController {
            searchVC.performSearch(query: query)
        }
    }
}

// MARK: - SeriesDetailViewDelegate
extension SeriesDetailViewController: SeriesDetailViewDelegate {
    func seriesDetailView(_ view: SeriesDetailView, didSelectCastMemberWithId id: Int) {
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
extension SeriesDetailViewController: UIScrollViewDelegate {
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
