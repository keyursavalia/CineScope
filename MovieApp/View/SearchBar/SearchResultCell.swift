import UIKit

final class SearchResultCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchResultCell"
    
    private var currentImageURL: URL?
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5  // placeholder color while loading
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mediaTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
        
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mediaTypeLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(ratingLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Poster image -- fixed size, left side, with padding
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Title -- top right of the image, with space for rating
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8),
            
            // Rating -- top right corner
            ratingLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingLabel.widthAnchor.constraint(equalToConstant: 40),
            
            // Media type -- below title
            mediaTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            mediaTypeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            mediaTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Overview -- below media type, fills remaining space
            overviewLabel.topAnchor.constraint(equalTo: mediaTypeLabel.bottomAnchor, constant: 4),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with item: MediaItem) {
        titleLabel.text = item.displayName
        overviewLabel.text = item.overview ?? "No description available"
        
        // Format media type nicely
        if let mediaType = item.mediaType {
            mediaTypeLabel.text = mediaType.capitalized  // "movie" → "Movie"
        } else {
            mediaTypeLabel.text = nil
        }
        
        // Rating (hide for people)
        if item.knownForDepartment != nil {
            ratingLabel.text = nil
        } else if let rating = item.voteAverage {
            ratingLabel.text = String(format: "⭐ %.1f", rating)
        } else {
            ratingLabel.text = nil
        }
    }
    
    func loadImage(from item: MediaItem, using imageService: ImageServiceProtocol) {
        currentImageURL = item.imageURL
        
        guard let url = item.imageURL else {
            posterImageView.image = nil
            return
        }
        
        Task {
            let image = try? await imageService.loadImage(from: url)
            
            // CRITICAL: Check that this cell hasn't been recycled
            if self.currentImageURL == url {
                self.posterImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        mediaTypeLabel.text = nil
        overviewLabel.text = nil
        ratingLabel.text = nil
    }
}
