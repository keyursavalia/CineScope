import UIKit

protocol MovieDetailViewDelegate: AnyObject {
    func movieDetailView(_ view: MovieDetailView, didSelectCastMemberWithId id: Int)
}

final class MovieDetailView: UIView {
    
    weak var delegate: MovieDetailViewDelegate?
    
    private var castItems: [CastDisplayItem] = []
    
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
        label.font = .systemFont(ofSize: 32, weight: .bold)
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
    
    private let metadataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        image.backgroundColor = .systemGray5
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Cast Section
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 140)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseIdentifier)
        return cv
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
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        ratingStack.addArrangedSubview(ratingLabel)
        ratingStack.addArrangedSubview(starImageView)
        
        titleRatingStack.addArrangedSubview(movieNameLabel)
        titleRatingStack.addArrangedSubview(ratingStack)
        
        descriptionContainerView.addSubview(movieDescriptionLabel)
        
        imageDescriptionStack.addArrangedSubview(movieImageView)
        imageDescriptionStack.addArrangedSubview(descriptionContainerView)
        
        contentView.addSubview(titleRatingStack)
        contentView.addSubview(genreScrollView)
        contentView.addSubview(metadataLabel)
        contentView.addSubview(imageDescriptionStack)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(castCollectionView)
        
        genreScrollView.addSubview(genreStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // 1. Title & Rating Stack
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            titleRatingStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleRatingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleRatingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 2. Genre (right below title)
            genreScrollView.topAnchor.constraint(equalTo: titleRatingStack.bottomAnchor, constant: 12),
            genreScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genreScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genreScrollView.heightAnchor.constraint(equalToConstant: 32),
            
            genreStackView.topAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.topAnchor),
            genreStackView.leadingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.leadingAnchor),
            genreStackView.trailingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.trailingAnchor),
            genreStackView.bottomAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.bottomAnchor),
            genreStackView.heightAnchor.constraint(equalTo: genreScrollView.frameLayoutGuide.heightAnchor),
            
            // 3. Metadata (runtime · release date) below genres
            metadataLabel.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: 10),
            metadataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            metadataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 4. Image & Description Stack below metadata
            imageDescriptionStack.topAnchor.constraint(equalTo: metadataLabel.bottomAnchor, constant: 16),
            imageDescriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageDescriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Poster Image sizing
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.4),
            
            // Description label inside container
            movieDescriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 10),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 10),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -10),
            movieDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: descriptionContainerView.bottomAnchor, constant: -10),
            
            // 5. Cast section
            castTitleLabel.topAnchor.constraint(equalTo: imageDescriptionStack.bottomAnchor, constant: 24),
            castTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            castTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            castCollectionView.topAnchor.constraint(equalTo: castTitleLabel.bottomAnchor, constant: 12),
            castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: 150),
            castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
    
    // MARK: - Public Interface
    var internalScrollView: UIScrollView { scrollView }
    
    // MARK: - Public Methods
    func update(with model: MovieDisplayModel) {
        movieNameLabel.text = model.title
        movieDescriptionLabel.text = model.overview
        ratingLabel.text = model.ratingText
        ratingLabel.textColor = model.ratingColor
        starImageView.tintColor = model.ratingColor
        movieImageView.image = model.image
        
        // Runtime and release date on one line
        let metadataParts = [model.formattedRuntime, model.formattedReleaseDate].compactMap { $0 }
        metadataLabel.text = metadataParts.joined(separator: " · ")
        metadataLabel.isHidden = metadataParts.isEmpty
        
        // Genres
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for genreName in model.genres {
            let pill = createGenrePill(with: genreName)
            pill.widthAnchor.constraint(equalToConstant: CGFloat(genreName.count * 8 + 20)).isActive = true
            pill.heightAnchor.constraint(equalToConstant: 24).isActive = true
            genreStackView.addArrangedSubview(pill)
        }
    }
    
    func updateCast(with items: [CastDisplayItem]) {
        castItems = items
        castTitleLabel.isHidden = items.isEmpty
        castCollectionView.isHidden = items.isEmpty
        castCollectionView.reloadData()
    }
    
    func clear() {
        movieNameLabel.text = nil
        metadataLabel.text = nil
        movieDescriptionLabel.text = nil
        ratingLabel.text = nil
        movieImageView.image = nil
        castItems = []
        castCollectionView.reloadData()
    }
}

// MARK: - Cast CollectionView
extension MovieDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseIdentifier, for: indexPath) as? CastCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: castItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = castItems[indexPath.item]
        delegate?.movieDetailView(self, didSelectCastMemberWithId: item.id)
    }
}
