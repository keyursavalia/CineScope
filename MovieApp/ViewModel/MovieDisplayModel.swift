import UIKit

struct MovieDisplayModel {
    let title: String
    let overview: String
    let rating: Float
    let image: UIImage?
    
    var ratingText: String {
        String(format: "%.1f ⭐️", rating)
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
