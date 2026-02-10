import UIKit

struct MovieDisplayModel {
    let title: String
    let tagline: String?
    let overview: String
    let ratingText: String
    let ratingColor: UIColor
    let genres: [String]
    let image: UIImage?
    let formattedRuntime: String?
    let formattedReleaseDate: String?
}
