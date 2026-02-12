import Foundation

extension MediaService {
    
    func fetchSeriesDetail(id: Int) async throws -> SeriesDetail {
        guard let url = URL(string: "\(baseURL)/tv/\(id)") else {
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
        
        return try JSONDecoder().decode(SeriesDetail.self, from: data)
    }
    
    func fetchSeriesCredits(id: Int) async throws -> CreditsResponse {
        guard let url = URL(string: "\(baseURL)/tv/\(id)/credits") else {
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
        
        return try JSONDecoder().decode(CreditsResponse.self, from: data)
    }
    
}
