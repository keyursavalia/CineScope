import Foundation

protocol GenreServiceProtocol {
    func fetchGenres() async throws -> [Genre]
}

