import UIKit

final class MovieDetailView: UIView {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleRatingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let imageDescriptionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search for a movie..."
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold) // Bold and Large
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: config)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let genreStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let genreScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let movieImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemBlue
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
        setupImageShadow()
    }
    
    private func addSubviews() {
        addSubview(searchBar)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        ratingStack.addArrangedSubview(ratingLabel)
        ratingStack.addArrangedSubview(starImageView)
        
        titleRatingStack.addArrangedSubview(movieNameLabel)
        titleRatingStack.addArrangedSubview(ratingStack)
        
        imageDescriptionStack.addArrangedSubview(movieImageView)
        imageDescriptionStack.addArrangedSubview(movieDescriptionLabel)
        
        contentView.addSubview(titleRatingStack)
        contentView.addSubview(imageDescriptionStack)
        contentView.addSubview(genreStackView)
        contentView.addSubview(genreScrollView)
        
        genreScrollView.addSubview(genreStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Search bar
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Title & Rating Stack
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            titleRatingStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleRatingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleRatingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Genre
            genreScrollView.topAnchor.constraint(equalTo: titleRatingStack.bottomAnchor, constant: 12),
            genreScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genreScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genreScrollView.heightAnchor.constraint(equalToConstant: 32),
            
            genreStackView.topAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.topAnchor),
            genreStackView.leadingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.leadingAnchor),
            genreStackView.trailingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.trailingAnchor),
            genreStackView.bottomAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.bottomAnchor),
            genreStackView.heightAnchor.constraint(equalTo: genreScrollView.frameLayoutGuide.heightAnchor),
            
            // Image & Description Stack
            imageDescriptionStack.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 24),
            imageDescriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageDescriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageDescriptionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Poster Image sizing inside the stack
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.4)
        ])
    }
    
    private func setupImageShadow() {
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowOpacity = 0.2
        movieImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        movieImageView.layer.shadowRadius = 8
    }
    
    private func createGenrePill(with name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .darkGray
        label.backgroundColor = UIColor.systemGray6
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }
    
    // MARK: - Public Methods
    func update(with model: MediaDisplayModel) {
        movieNameLabel.text = model.title
        movieDescriptionLabel.text = model.overview
        ratingLabel.text = model.ratingText
        ratingLabel.textColor = model.ratingColor
        starImageView.tintColor = model.ratingColor
        movieImageView.image = model.image
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        ratingStack.isHidden = model.isPerson
        
        for genreName in model.genres {
            let pill = createGenrePill(with: genreName)
            
            // Optional: Add padding to the pill
            pill.widthAnchor.constraint(equalToConstant: CGFloat(genreName.count * 8 + 20)).isActive = true
            pill.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            genreStackView.addArrangedSubview(pill)
        }
    }
    
    func clear() {
        movieNameLabel.text = nil
        movieDescriptionLabel.text = nil
        ratingLabel.text = nil
        movieImageView.image = nil
    }
}
