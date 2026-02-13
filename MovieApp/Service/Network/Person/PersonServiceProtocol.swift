import Foundation

protocol PersonServiceProtocol {
    func fetchPersonDetail(id: Int) async throws -> PersonDetail
    func fetchPersonImages(id: Int) async throws -> PersonImagesResponse
}
