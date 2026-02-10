import Foundation

extension MediaService {
    
    func fetchGenres() async throws -> [Genre] {
        guard let url = URL(string: "\(baseURL)/genre/movie/list") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiToken, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(GenreResponse.self, from: data)
        return response.genres
    }
    
}
