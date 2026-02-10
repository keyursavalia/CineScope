import Foundation

// MARK: - Person Detail
struct PersonDetail: Codable {
    let id: Int
    let name: String?
    let biography: String?
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let knownForDepartment: String?
    let gender: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday, deathday, gender
        case placeOfBirth = "place_of_birth"
        case knownForDepartment = "known_for_department"
    }
}

// MARK: - PersonDetail Computed Properties
extension PersonDetail {
    var formattedBirthday: String? {
        guard let dateString = birthday else { return nil }
        return Self.formatDate(dateString)
    }
    
    var formattedDeathday: String? {
        guard let dateString = deathday else { return nil }
        return Self.formatDate(dateString)
    }
    
    var ageText: String? {
        guard let birthday = birthday else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let birthDate = formatter.date(from: birthday) else { return nil }
        
        let endDate: Date
        if let deathday = deathday, let deathDate = formatter.date(from: deathday) {
            endDate = deathDate
        } else {
            endDate = Date()
        }
        
        let components = Calendar.current.dateComponents([.year], from: birthDate, to: endDate)
        guard let age = components.year else { return nil }
        
        if deathday != nil {
            return "Died at \(age)"
        }
        return "\(age) years old"
    }
    
    var birthInfo: String? {
        let parts = [formattedBirthday, placeOfBirth].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    var isAlive: Bool {
        return deathday == nil
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
