import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String) async throws -> [Movie]
}
