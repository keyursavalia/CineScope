import UIKit

struct MediaDisplayModel {
    let title: String
    let overview: String
    let rating: Float
    let image: UIImage?
    let genres: [String]
    let isPerson: Bool
    
    var ratingText: String {
        return isPerson ? "" : String(format: "%.1f", rating)
    }
    
    var ratingColor: UIColor {
        if rating >= 7.0 {
            return .systemGreen
        } else if rating >= 5.0 {
            return .systemOrange
        } else {
            return .systemRed
        }
    }
}
