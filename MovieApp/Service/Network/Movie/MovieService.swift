import Foundation

extension MediaService {
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }
    
}
