import Foundation

// MARK: - Movie Detail
struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let runtime: Int?
    let releaseDate: String?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case releaseDate = "release_date"
    }
}

extension MovieDetail {
    
    var formattedRuntime: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        
        let hours = runtime / 60
        let minutes = runtime % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    var formattedReleaseDate: String? {
        guard let releaseDate = releaseDate else { return nil }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: releaseDate) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.timeStyle = .none
        
        return outputFormatter.string(from: date)
    }
    
}
