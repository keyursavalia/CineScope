import Foundation
import UIKit

@MainActor
final class MediaViewModel {
    // Callback closures for UI updates
    var onMediaUpdated: ((MediaDisplayModel) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onSearchResultsUpdated: (([MediaItem]) -> Void)?
    
    private(set) var mediaItems: [MediaItem] = []
    
    private let mediaService: MediaServiceProtocol
    private let imageService: ImageServiceProtocol
    
    private(set) var isLoading = false {
        didSet {
            onLoadingChanged?(isLoading)
        }
    }
    
    // Dependency injection for testability
    // nonisolated allows this to be called from any context
    nonisolated init(
        movieService: MediaServiceProtocol = MediaService(),
        imageService: ImageServiceProtocol = ImageService()
    ) {
        self.mediaService = movieService
        self.imageService = imageService
    }
    
    func searchMulti(query: String) {
        guard !query.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                let items = try await mediaService.searchMulti(query: query)
                
                guard !items.isEmpty else {
                    self.isLoading = false
                    self.onError?("No results found")
                    return
                }
                
                self.mediaItems = items
                self.isLoading = false
                self.onSearchResultsUpdated?(items)
                
            } catch {
                self.isLoading = false
                self.onError?("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func buildDisplayModel(for item: MediaItem) async -> MediaDisplayModel {
        let title = item.title ?? item.name ?? "Unknown"
        let overview = item.overview ?? "Sorry! We could not find the words to describe this :("
        let rating = item.voteAverage ?? 0.0
        let isPerson = item.knownForDepartment != nil
        
        // Resolve genres
        let genres: [String]
        if item.mediaType == "person" {
            genres = [item.knownForDepartment ?? "Unknown"]
        } else {
            genres = item.genreNames(using: GenreManager.shared.genres)
        }
        
        // Load the poster image
        var image: UIImage? = nil
        if let posterPath = item.displayImagePath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            image = try? await imageService.loadImage(from: url)
        }
        
        return MediaDisplayModel(
            title: title,
            overview: overview,
            rating: rating,
            image: image,
            genres: genres,
            isPerson: isPerson
        )
    }
}
