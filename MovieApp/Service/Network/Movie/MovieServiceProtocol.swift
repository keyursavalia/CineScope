import Foundation

protocol MovieServiceProtocol {
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchMovieCredits(id: Int) async throws -> CreditsResponse
}
