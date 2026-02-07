import UIKit

final class ImageService: ImageServiceProtocol {
    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()
    
    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 100
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        // Check cache first
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        // Download image
        let (data, _) = try await session.data(from: url)
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        // Cache the image
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
