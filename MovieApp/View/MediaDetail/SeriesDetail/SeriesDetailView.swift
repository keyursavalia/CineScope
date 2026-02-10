import UIKit

final class SeriesDetailView: UIView {
    
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
    
    private let showNameLabel: UILabel = {
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
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Status · Year range  (e.g. "Ended · 2011 – 2019")
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Seasons · Episodes  (e.g. "8 Seasons · 73 Episodes")
    private let seasonEpisodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Network · Creators  (e.g. "HBO · David Benioff, D.B. Weiss")
    private let networkCreatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
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
    
    private let showImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray5
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let showDescriptionLabel: UILabel = {
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        ratingStack.addArrangedSubview(ratingLabel)
        ratingStack.addArrangedSubview(starImageView)
        
        titleRatingStack.addArrangedSubview(showNameLabel)
        titleRatingStack.addArrangedSubview(ratingStack)
        
        imageDescriptionStack.addArrangedSubview(showImageView)
        imageDescriptionStack.addArrangedSubview(showDescriptionLabel)
        
        contentView.addSubview(titleRatingStack)
        contentView.addSubview(taglineLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(seasonEpisodeLabel)
        contentView.addSubview(networkCreatorLabel)
        contentView.addSubview(genreScrollView)
        contentView.addSubview(imageDescriptionStack)
        
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
            
            // Title & Rating
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            titleRatingStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleRatingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleRatingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Tagline
            taglineLabel.topAnchor.constraint(equalTo: titleRatingStack.bottomAnchor, constant: 8),
            taglineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taglineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Status · Year range
            statusLabel.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Seasons · Episodes
            seasonEpisodeLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            seasonEpisodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            seasonEpisodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Network · Creators
            networkCreatorLabel.topAnchor.constraint(equalTo: seasonEpisodeLabel.bottomAnchor, constant: 4),
            networkCreatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            networkCreatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Genre
            genreScrollView.topAnchor.constraint(equalTo: networkCreatorLabel.bottomAnchor, constant: 12),
            genreScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genreScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genreScrollView.heightAnchor.constraint(equalToConstant: 32),
            
            genreStackView.topAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.topAnchor),
            genreStackView.leadingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.leadingAnchor),
            genreStackView.trailingAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.trailingAnchor),
            genreStackView.bottomAnchor.constraint(equalTo: genreScrollView.contentLayoutGuide.bottomAnchor),
            genreStackView.heightAnchor.constraint(equalTo: genreScrollView.frameLayoutGuide.heightAnchor),
            
            // Image & Description
            imageDescriptionStack.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: 24),
            imageDescriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageDescriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageDescriptionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Poster sizing
            showImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            showImageView.heightAnchor.constraint(equalTo: showImageView.widthAnchor, multiplier: 1.4)
        ])
    }
    
    private func setupImageShadow() {
        showImageView.layer.shadowColor = UIColor.black.cgColor
        showImageView.layer.shadowOpacity = 0.2
        showImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        showImageView.layer.shadowRadius = 8
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
    func update(with model: SeriesDisplayModel) {
        showNameLabel.text = model.title
        taglineLabel.text = model.tagline
        showDescriptionLabel.text = model.overview
        ratingLabel.text = model.ratingText
        ratingLabel.textColor = model.ratingColor
        starImageView.tintColor = model.ratingColor
        showImageView.image = model.image
        
        // Status · Year range
        let statusParts = [model.status, model.yearRange].compactMap { $0 }
        statusLabel.text = statusParts.joined(separator: " · ")
        statusLabel.isHidden = statusParts.isEmpty
        
        // Seasons · Episodes
        seasonEpisodeLabel.text = model.seasonEpisodeText
        seasonEpisodeLabel.isHidden = (model.seasonEpisodeText == nil)
        
        // Network · Creators
        let networkCreatorParts = [model.networkName, model.creatorNames].compactMap { $0 }
        networkCreatorLabel.text = networkCreatorParts.joined(separator: " · ")
        networkCreatorLabel.isHidden = networkCreatorParts.isEmpty
        
        // Tagline
        taglineLabel.isHidden = (model.tagline == nil || model.tagline?.isEmpty == true)
        
        // Genres
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for genreName in model.genres {
            let pill = createGenrePill(with: genreName)
            pill.widthAnchor.constraint(equalToConstant: CGFloat(genreName.count * 8 + 20)).isActive = true
            pill.heightAnchor.constraint(equalToConstant: 24).isActive = true
            genreStackView.addArrangedSubview(pill)
        }
    }
    
    func clear() {
        showNameLabel.text = nil
        taglineLabel.text = nil
        statusLabel.text = nil
        seasonEpisodeLabel.text = nil
        networkCreatorLabel.text = nil
        showDescriptionLabel.text = nil
        ratingLabel.text = nil
        showImageView.image = nil
    }
}
