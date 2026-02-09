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
    let genreIds: [Int]
    
    var fullPosterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    enum CodingKeys: String, CodingKey {
        case title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    func genreNames(using dictionary: [Int: String]) -> [String] {
        let names = genreIds.compactMap { dictionary[$0] }
        return names.isEmpty ? ["Unknown Genre"] : names
    }
}

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
