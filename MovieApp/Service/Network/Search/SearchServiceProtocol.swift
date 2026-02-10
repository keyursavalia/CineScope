import Foundation

protocol SearchServiceProtocol {
    func searchMulti(query: String) async throws -> [MediaItem]
}
