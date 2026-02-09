import Foundation

final class MovieService: MovieServiceProtocol {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiToken: String
    private let session: URLSession
    
    // Dependency injection for testability
    init(apiToken: String = APIKey.accessToken, session: URLSession = .shared) {
        self.apiToken = apiToken
        self.session = session
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/movie?query=\(encodedQuery)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            return movieResponse.results
            
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
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
