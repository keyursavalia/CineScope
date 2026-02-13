import UIKit

final class PersonImageCarouselView: UIView {
    
    var imageService: ImageServiceProtocol?
    private var imageURLs: [URL] = []
    private var currentPage = 0
    private var isInfiniteScrollEnabled: Bool {
        return imageURLs.count > 1
    }
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PersonImageCell.self, forCellWithReuseIdentifier: PersonImageCell.reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let leftArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        // Add subtle shadow to arrow buttons
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    private let rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        // Add subtle shadow to arrow buttons
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.isUserInteractionEnabled = false
        pc.hidesForSinglePage = true
        pc.backgroundStyle = .minimal
        return pc
    }()
    
    private let leftGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.3, 1]
        return gradient
    }()
    
    private let rightGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.7, 1]
        return gradient
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
        backgroundColor = .systemGray6
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // Add subtle border
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.separator.withAlphaComponent(0.3).cgColor
        
        addSubview(collectionView)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(pageControl)
        
        layer.addSublayer(leftGradientLayer)
        layer.addSublayer(rightGradientLayer)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftArrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 36),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 36),
            
            rightArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightArrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 36),
            rightArrowButton.heightAnchor.constraint(equalToConstant: 36),
            
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
        
        // Show arrows initially to indicate scrollability
        showArrowsTemporarily()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update gradient layers
        let gradientWidth: CGFloat = 60
        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: gradientWidth, height: bounds.height)
        rightGradientLayer.frame = CGRect(x: bounds.width - gradientWidth, y: 0, width: gradientWidth, height: bounds.height)
        
        // Update collection view layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = bounds.size
        }
    }
    
    // MARK: - Public Methods
    func configure(with imageURLs: [URL]) {
        self.imageURLs = imageURLs
        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = 0
        currentPage = 0
        collectionView.reloadData()
        updateArrowVisibility()
        
        // For infinite scroll, start at index 1 (first real item after the clone)
        if isInfiniteScrollEnabled {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        
        // Show arrows temporarily when content loads
        if imageURLs.count > 1 {
            showArrowsTemporarily()
        }
    }
    
    // MARK: - Private Methods
    private func updateArrowVisibility() {
        // Always enable arrows for circular scrolling
        leftArrowButton.isEnabled = imageURLs.count > 1
        rightArrowButton.isEnabled = imageURLs.count > 1
        
        // Always show gradients if we have multiple images
        leftGradientLayer.isHidden = imageURLs.count <= 1
        rightGradientLayer.isHidden = imageURLs.count <= 1
    }
    
    private func showArrowsTemporarily() {
        guard imageURLs.count > 1 else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.leftArrowButton.alpha = 1
            self.rightArrowButton.alpha = 1
        }
        
        // Keep arrows visible for longer initially (4 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.fadeOutArrows()
        }
    }
    
    private func showArrows() {
        guard imageURLs.count > 1 else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fadeOutArrowsSelector), object: nil)
        
        UIView.animate(withDuration: 0.2) {
            self.leftArrowButton.alpha = 1
            self.rightArrowButton.alpha = 1
        }
    }
    
    private func fadeOutArrows() {
        guard imageURLs.count > 1 else { return }
        UIView.animate(withDuration: 0.3) {
            self.leftArrowButton.alpha = 0
            self.rightArrowButton.alpha = 0
        }
    }
    
    @objc private func fadeOutArrowsSelector() {
        fadeOutArrows()
    }
    
    @objc private func leftArrowTapped() {
        guard imageURLs.count > 0 else { return }
        
        // Button animation
        animateButtonPress(leftArrowButton)
        
        if isInfiniteScrollEnabled {
            let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
            let targetIndex = currentIndex - 1
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            // Single item, do nothing
            return
        }
    }
    
    @objc private func rightArrowTapped() {
        guard imageURLs.count > 0 else { return }
        
        // Button animation
        animateButtonPress(rightArrowButton)
        
        if isInfiniteScrollEnabled {
            let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
            let targetIndex = currentIndex + 1
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            // Single item, do nothing
            return
        }
    }
    
    private func animateButtonPress(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        showArrows()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // Fade out arrows after a longer delay
        perform(#selector(fadeOutArrowsSelector), with: nil, afterDelay: 2.5)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        perform(#selector(fadeOutArrowsSelector), with: nil, afterDelay: 2.5)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension PersonImageCarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // For infinite scroll: add 2 extra items (clones at beginning and end)
        guard isInfiniteScrollEnabled else { return imageURLs.count }
        return imageURLs.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonImageCell.reuseIdentifier, for: indexPath) as? PersonImageCell else {
            return UICollectionViewCell()
        }
        
        if let service = imageService {
            let actualIndex = getActualIndex(for: indexPath.item)
            cell.configure(with: imageURLs[actualIndex], imageService: service)
        }
        
        return cell
    }
    
    // Convert collection view index to actual image index
    private func getActualIndex(for index: Int) -> Int {
        guard isInfiniteScrollEnabled else { return index }
        
        if index == 0 {
            // First item is clone of last
            return imageURLs.count - 1
        } else if index == imageURLs.count + 1 {
            // Last item is clone of first
            return 0
        } else {
            // Regular items
            return index - 1
        }
    }
    
    private func updatePageControl() {
        guard isInfiniteScrollEnabled else { return }
        
        let currentIndex = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        
        if currentIndex == 0 {
            pageControl.currentPage = imageURLs.count - 1
        } else if currentIndex == imageURLs.count + 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = currentIndex - 1
        }
        
        currentPage = pageControl.currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isInfiniteScrollEnabled else { return }
        
        let pageWidth = scrollView.bounds.width
        let currentOffset = scrollView.contentOffset.x
        let currentIndex = currentOffset / pageWidth
        
        // Check if we've scrolled to a clone and need to jump to the real item
        if currentOffset <= 0 {
            // At or before first clone - jump to last real item
            let lastRealIndex = imageURLs.count
            scrollView.contentOffset = CGPoint(x: CGFloat(lastRealIndex) * pageWidth, y: 0)
        } else if currentOffset >= CGFloat(imageURLs.count + 1) * pageWidth {
            // At or after last clone - jump to first real item
            scrollView.contentOffset = CGPoint(x: pageWidth, y: 0)
        }
        
        updatePageControl()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd()
        
        // Show arrows briefly after scrolling
        showArrows()
        perform(#selector(fadeOutArrowsSelector), with: nil, afterDelay: 2.5)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    private func handleScrollEnd() {
        guard isInfiniteScrollEnabled else { return }
        
        let pageWidth = collectionView.bounds.width
        let currentOffset = collectionView.contentOffset.x
        let currentIndex = Int(round(currentOffset / pageWidth))
        
        // If we're on a clone, instantly jump to the real item
        if currentIndex == 0 {
            // On first clone - jump to last real item
            collectionView.scrollToItem(at: IndexPath(item: imageURLs.count, section: 0), at: .centeredHorizontally, animated: false)
            pageControl.currentPage = imageURLs.count - 1
            currentPage = imageURLs.count - 1
        } else if currentIndex == imageURLs.count + 1 {
            // On last clone - jump to first real item
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            pageControl.currentPage = 0
            currentPage = 0
        } else {
            // On a real item
            pageControl.currentPage = currentIndex - 1
            currentPage = currentIndex - 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Show arrows when user starts dragging
        showArrows()
    }
}

// MARK: - PersonImageCell
final class PersonImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PersonImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with url: URL, imageService: ImageServiceProtocol) {
        imageView.image = nil
        imageView.alpha = 0
        activityIndicator.startAnimating()
        
        Task {
            let image = try? await imageService.loadImage(from: url)
            await MainActor.run {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                
                // Smooth fade-in animation
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.imageView.alpha = 1
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.alpha = 0
        activityIndicator.stopAnimating()
    }
}
