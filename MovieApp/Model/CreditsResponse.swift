import Foundation

// MARK: - Credits Response
struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastMember]?
}

// MARK: - Cast Member
struct CastMember: Codable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character, order
        case profilePath = "profile_path"
    }
}
