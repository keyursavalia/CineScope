import UIKit

protocol ImageServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage?
}
