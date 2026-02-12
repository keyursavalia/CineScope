import UIKit

final class GalleryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryCell"
    
    private var currentURL: URL?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// Subtle bottom gradient for depth
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.15).cgColor
        ]
        layer.locations = [0.6, 1.0]
        return layer
    }()
    
    /// Shimmer placeholder view
    private let shimmerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
        
        // Shadow on the cell itself (not clipped)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.cornerRadius = 14
        
        contentView.addSubview(imageView)
        contentView.addSubview(shimmerView)
        imageView.layer.addSublayer(gradientLayer)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        startShimmerAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 14).cgPath
    }
    
    // MARK: - Shimmer Animation
    private func startShimmerAnimation() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 400, height: 250)
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        shimmerView.layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    // MARK: - Configure
    func configure(with url: URL, imageService: ImageServiceProtocol) {
        currentURL = url
        shimmerView.isHidden = false
        imageView.image = nil
        
        Task {
            let image = try? await imageService.loadImage(from: url)
            // Prevent stale image from recycled cell
            guard self.currentURL == url else { return }
            
            UIView.transition(with: self.imageView, duration: 0.25, options: .transitionCrossDissolve) {
                self.imageView.image = image
            }
            self.shimmerView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentURL = nil
        imageView.image = nil
        shimmerView.isHidden = false
    }
}
