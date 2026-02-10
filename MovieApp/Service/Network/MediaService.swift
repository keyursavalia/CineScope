import Foundation

final class MediaService: MediaServiceProtocol {
    let baseURL = "https://api.themoviedb.org/3"
    let apiToken: String
    let session: URLSession
    
    // Dependency injection for testability
    init(apiToken: String = APIKey.accessToken, session: URLSession = .shared) {
        self.apiToken = apiToken
        self.session = session
    }
}
