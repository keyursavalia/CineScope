import Foundation

protocol PersonServiceProtocol {
    func fetchPersonDetail(id: Int) async throws -> PersonDetail
}
