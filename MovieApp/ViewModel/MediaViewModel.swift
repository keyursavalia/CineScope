import Foundation
import UIKit

@MainActor
final class MediaViewModel {
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
    
    func searchMulti(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                let movies = try await movieService.searchMulti(query: query)
                
                guard let firstItem = movies.first else {
                    self.isLoading = false
                    self.onError?("No movies found")
                    return
                }
                
                let title = firstItem.title
                let name = firstItem.name
                let overview = firstItem.overview ?? "Sorry! We could not find the words to describe this :("
                let rating = firstItem.voteAverage
                let knownForDepartment = firstItem.knownForDepartment
                
                let genres: [String]
                if firstItem.mediaType == "person" {
                    genres = ["knownForDepartment"]
                } else {
                    genres = firstItem.genreNames(using: GenreManager.shared.genres)
                }
                
                // Load image
                var image: UIImage? = nil
                if let posterURL = firstItem.displayImagePath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterURL)") {
                    image = try? await imageService.loadImage(from: url)
                }
                
                // Create display model
                let displayModel = MovieDisplayModel(
                    title: title ?? name ?? "unknown",
                    overview: overview,
                    rating: rating ?? 0.0,
                    image: image,
                    genres: genres,
                    isPerson: knownForDepartment != nil
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
