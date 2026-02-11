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
        label.font = .italicSystemFont(ofSize: 17)
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let showDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
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
        
        // Description label inside container
        descriptionContainerView.addSubview(showDescriptionLabel)
        
        imageDescriptionStack.addArrangedSubview(showImageView)
        imageDescriptionStack.addArrangedSubview(descriptionContainerView)
        
        contentView.addSubview(titleRatingStack)
        contentView.addSubview(genreScrollView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(seasonEpisodeLabel)
        contentView.addSubview(taglineLabel)
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
            
            // 1. Title & Rating
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
            
            // 3. Status · Year range (below genres)
            statusLabel.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Seasons · Episodes
            seasonEpisodeLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            seasonEpisodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            seasonEpisodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 4. Tagline (centered, styled) below metadata
            taglineLabel.topAnchor.constraint(equalTo: seasonEpisodeLabel.bottomAnchor, constant: 14),
            taglineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taglineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 5. Image & Description below tagline
            imageDescriptionStack.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 20),
            imageDescriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageDescriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageDescriptionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Poster sizing (smaller)
            showImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38),
            showImageView.heightAnchor.constraint(equalTo: showImageView.widthAnchor, multiplier: 1.4),
            
            // Description label inside container
            showDescriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 10),
            showDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 10),
            showDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -10),
            showDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: descriptionContainerView.bottomAnchor, constant: -10)
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
        showDescriptionLabel.text = nil
        ratingLabel.text = nil
        showImageView.image = nil
    }
}
