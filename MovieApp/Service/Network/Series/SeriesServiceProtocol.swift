import Foundation

protocol SeriesServiceProtocol {
    func fetchSeriesDetail(id: Int) async throws -> SeriesDetail
    func fetchSeriesCredits(id: Int) async throws -> CreditsResponse
}
