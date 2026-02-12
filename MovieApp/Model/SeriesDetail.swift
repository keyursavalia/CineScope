import Foundation

// MARK: - TV Show Detail
struct SeriesDetail: Codable {
    let id: Int
    let name: String
    let overview: String?
    let status: String?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let firstAirDate: String?
    let lastAirDate: String?
    let inProduction: Bool?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, status, genres
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case inProduction = "in_production"
    }
}

// MARK: - TVShowDetail Computed Properties
extension SeriesDetail {
    var formattedFirstAirDate: String? {
        guard let dateString = firstAirDate else { return nil }
        return Self.formatDate(dateString)
    }
    
    var formattedLastAirDate: String? {
        guard let dateString = lastAirDate else { return nil }
        return Self.formatDate(dateString)
    }
    
    /// "2011 – 2019" or "2011 – Present"
    var yearRange: String? {
        guard let firstDate = firstAirDate, firstDate.count >= 4 else { return nil }
        let startYear = String(firstDate.prefix(4))
        
        if inProduction == true {
            return "\(startYear) – Present"
        } else if let lastDate = lastAirDate, lastDate.count >= 4 {
            let endYear = String(lastDate.prefix(4))
            return startYear == endYear ? startYear : "\(startYear) – \(endYear)"
        }
        return startYear
    }
    
    /// "8 Seasons · 73 Episodes"
    var seasonEpisodeText: String? {
        var parts: [String] = []
        if let seasons = numberOfSeasons, seasons > 0 {
            parts.append("\(seasons) Season\(seasons == 1 ? "" : "s")")
        }
        if let episodes = numberOfEpisodes, episodes > 0 {
            parts.append("\(episodes) Episode\(episodes == 1 ? "" : "s")")
        }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    private static func formatDate(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: dateString) else { return nil }
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.timeStyle = .none
        return outputFormatter.string(from: date)
    }
}
