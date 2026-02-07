import Foundation

// outer
struct MovieResponse: Codable {
    let results: [Movie]
}

// inner
struct Movie: Codable {
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Float
    
    var fullPosterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    enum CodingKeys: String, CodingKey {
        case title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
