import UIKit

final class SearchBarView: UIView {
    
    weak var delegate: SearchBarViewDelegate?
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search movies, TV shows, people..."
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchBar)
        searchBar.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Public method to dismiss the keyboard from outside
    func resignSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    // Public method to pre-fill the search text
    func setSearchText(_ text: String) {
        searchBar.text = text
    }
}

extension SearchBarView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        delegate?.searchBarView(self, didSearchFor: text)
    }
}

protocol SearchBarViewDelegate: AnyObject {
    func searchBarView(_ searchBarView: SearchBarView, didSearchFor query: String)
}
