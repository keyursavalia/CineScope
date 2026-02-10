import Foundation

protocol SeriesServiceProtocol {
    func fetchSeriesDetail(id: Int) async throws -> SeriesDetail
}
