import UIKit

final class PersonDetailView: UIView {
    
    var imageService: ImageServiceProtocol?
    
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
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let departmentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deathdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageCarouselView: PersonImageCarouselView = {
        let carousel = PersonImageCarouselView()
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    private let biographyContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let biographyLabel: UILabel = {
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
        
        biographyContainerView.addSubview(biographyLabel)
        
        contentView.addSubview(personNameLabel)
        contentView.addSubview(departmentLabel)
        contentView.addSubview(birthInfoLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(deathdayLabel)
        contentView.addSubview(imageCarouselView)
        contentView.addSubview(biographyContainerView)
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
            
            // Name
            personNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            personNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            personNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Department
            departmentLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 4),
            departmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            departmentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Birth info
            birthInfoLabel.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor, constant: 8),
            birthInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Age
            ageLabel.topAnchor.constraint(equalTo: birthInfoLabel.bottomAnchor, constant: 4),
            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Deathday
            deathdayLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 4),
            deathdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deathdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Image carousel — full width
            imageCarouselView.topAnchor.constraint(equalTo: deathdayLabel.bottomAnchor, constant: 20),
            imageCarouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageCarouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageCarouselView.heightAnchor.constraint(equalTo: imageCarouselView.widthAnchor, multiplier: 1.2),
            
            // Biography container below image
            biographyContainerView.topAnchor.constraint(equalTo: imageCarouselView.bottomAnchor, constant: 16),
            biographyContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            biographyContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            biographyContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Biography label inside container
            biographyLabel.topAnchor.constraint(equalTo: biographyContainerView.topAnchor, constant: 12),
            biographyLabel.leadingAnchor.constraint(equalTo: biographyContainerView.leadingAnchor, constant: 12),
            biographyLabel.trailingAnchor.constraint(equalTo: biographyContainerView.trailingAnchor, constant: -12),
            biographyLabel.bottomAnchor.constraint(equalTo: biographyContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupImageShadow() {
        imageCarouselView.layer.shadowColor = UIColor.black.cgColor
        imageCarouselView.layer.shadowOpacity = 0.15
        imageCarouselView.layer.shadowOffset = CGSize(width: 0, height: 6)
        imageCarouselView.layer.shadowRadius = 12
        imageCarouselView.layer.masksToBounds = false
    }
    
    // MARK: - Public Interface
    var internalScrollView: UIScrollView { scrollView }
    
    // MARK: - Public Methods
    func update(with model: PersonDisplayModel) {
        personNameLabel.text = model.name
        biographyLabel.text = model.biography
        
        // If we have a fallback image from the model, use it
        if let image = model.image {
            let url = URL(string: "placeholder")!
            imageCarouselView.configure(with: [url])
            // Manually set the first image
            if let service = imageService {
                Task {
                    // This is just for fallback; will be replaced by actual images
                }
            }
        }
        
        // Department
        departmentLabel.text = model.knownForDepartment
        departmentLabel.isHidden = (model.knownForDepartment == nil)
        
        // Birth info
        birthInfoLabel.text = model.birthInfo
        birthInfoLabel.isHidden = (model.birthInfo == nil)
        
        // Age
        ageLabel.text = model.ageText
        ageLabel.isHidden = (model.ageText == nil)
        
        // Deathday
        if let deathday = model.deathday {
            deathdayLabel.text = "Died \(deathday)"
            deathdayLabel.isHidden = false
        } else {
            deathdayLabel.isHidden = true
        }
    }
    
    func updateImages(with urls: [URL]) {
        imageCarouselView.imageService = imageService
        imageCarouselView.configure(with: urls)
    }
    
    func clear() {
        personNameLabel.text = nil
        departmentLabel.text = nil
        birthInfoLabel.text = nil
        ageLabel.text = nil
        deathdayLabel.text = nil
        biographyLabel.text = nil
        imageCarouselView.configure(with: [])
    }
}
