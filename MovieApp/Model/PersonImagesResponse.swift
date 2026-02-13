import Foundation

// MARK: - Person Images Response
struct PersonImagesResponse: Codable {
    let id: Int
    let profiles: [ProfileImage]
}

// MARK: - Profile Image
struct ProfileImage: Codable {
    let aspectRatio: Double?
    let height: Int?
    let width: Int?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case height, width
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
