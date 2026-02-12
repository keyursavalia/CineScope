import Foundation

// MARK: - Images Response
struct ImagesResponse: Codable {
    let id: Int
    let backdrops: [ImageItem]?
    let posters: [ImageItem]?
}

// MARK: - Image Item
struct ImageItem: Codable {
    let filePath: String
    let aspectRatio: Double?
    let width: Int?
    let height: Int?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case aspectRatio = "aspect_ratio"
        case width, height
        case voteAverage = "vote_average"
    }
}
