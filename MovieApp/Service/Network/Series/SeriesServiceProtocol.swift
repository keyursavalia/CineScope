import Foundation

protocol SeriesServiceProtocol {
    func fetchSeriesDetail(id: Int) async throws -> SeriesDetail
    func fetchSeriesCredits(id: Int) async throws -> CreditsResponse
    func fetchSeriesImages(id: Int) async throws -> ImagesResponse
}
