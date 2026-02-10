import Foundation

// MARK: - Search Multi Response
struct SearchResponse: Codable {
    let results: [MediaItem]
}

// MARK: - Media Item (polymorphic search result)
struct MediaItem: Codable {
    let id: Int?
    let title: String?
    let name: String?
    let mediaType: String?
    let overview: String?
    let posterPath: String?
    let profilePath: String?
    let voteAverage: Float?
    let genreIds: [Int]?
    let knownForDepartment: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, name
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
        case knownForDepartment = "known_for_department"
    }
}

// MARK: - MediaItem Computed Properties
extension MediaItem {
    var displayName: String? {
        return title ?? name ?? "Unknown"
    }
    
    var displayImagePath: String? {
        return posterPath ?? profilePath
    }
    
    var imageURL: URL? {
        guard let path = displayImagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    func genreNames(using dictionary: [Int: String]) -> [String] {
        guard let genreIds = genreIds else { return [] }
        let names = genreIds.compactMap { dictionary[$0] }
        return names.isEmpty ? ["Unknown Genre"] : names
    }
}
