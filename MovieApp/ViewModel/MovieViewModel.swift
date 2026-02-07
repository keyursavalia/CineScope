import Foundation
import UIKit

@MainActor
final class MovieViewModel {
    // Callback closures for UI updates
    var onMovieUpdated: ((MovieDisplayModel) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    
    private let movieService: MovieServiceProtocol
    private let imageService: ImageServiceProtocol
    
    private(set) var isLoading = false {
        didSet {
            onLoadingChanged?(isLoading)
        }
    }
    
    // Dependency injection for testability
    // nonisolated allows this to be called from any context
    nonisolated init(
        movieService: MovieServiceProtocol = MovieService(),
        imageService: ImageServiceProtocol = ImageService()
    ) {
        self.movieService = movieService
        self.imageService = imageService
    }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                let movies = try await movieService.searchMovies(query: query)
                
                guard let firstMovie = movies.first else {
                    self.isLoading = false
                    self.onError?("No movies found")
                    return
                }
                
                // Load image
                var image: UIImage? = nil
                if let posterURL = firstMovie.fullPosterURL {
                    image = try? await imageService.loadImage(from: posterURL)
                }
                
                // Create display model
                let displayModel = MovieDisplayModel(
                    title: firstMovie.title,
                    overview: firstMovie.overview,
                    rating: firstMovie.voteAverage,
                    image: image
                )
                
                self.isLoading = false
                self.onMovieUpdated?(displayModel)
                
            } catch {
                self.isLoading = false
                self.onError?("Error: \(error.localizedDescription)")
            }
        }
    }
}
