import Foundation

protocol MovieServiceProtocol {
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
}
