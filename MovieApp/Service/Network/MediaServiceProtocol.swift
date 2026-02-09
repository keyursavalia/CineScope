import Foundation

protocol MediaServiceProtocol {
    func searchMulti(query: String) async throws -> [MediaItem]
    func fetchGenres() async throws -> [Genre]
}
