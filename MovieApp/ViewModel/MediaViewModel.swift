import Foundation
import UIKit

@MainActor
final class MediaViewModel {
    // Callback closures for UI updates
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
    
    func buildMovieDisplayModel(for item: MediaItem) async -> MovieDisplayModel {
        // Fetch the full movie detail from /movie/{id}
        var movieDetail: MovieDetail? = nil
        if let movieId = item.id {
            movieDetail = try? await mediaService.fetchMovieDetail(id: movieId)
        }
        
        let title = movieDetail?.title ?? item.title ?? "Unknown"
        let tagline = movieDetail?.tagline
        let overview = movieDetail?.overview ?? item.overview ?? "No description available"
        let rating = item.voteAverage ?? 0.0
        
        // Genres from the detail response if available, otherwise fall back to search response
        let genres: [String]
        if let detailGenres = movieDetail?.genres, !detailGenres.isEmpty {
            genres = detailGenres.map { $0.name }
        } else {
            genres = item.genreNames(using: GenreManager.shared.genres)
        }
        
        // Load poster image
        var image: UIImage? = nil
        if let posterPath = item.displayImagePath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            image = try? await imageService.loadImage(from: url)
        }
        
        let ratingText = String(format: "%.1f", rating)
        let ratingColor: UIColor = rating >= 7.0 ? .systemGreen : (rating >= 5.0 ? .systemOrange : .systemRed)
        
        return MovieDisplayModel(
            title: title,
            tagline: tagline,
            overview: overview,
            ratingText: ratingText,
            ratingColor: ratingColor,
            genres: genres,
            image: image,
            formattedRuntime: movieDetail?.formattedRuntime,
            formattedReleaseDate: movieDetail?.formattedReleaseDate
        )
    }
    
    func buildSeriesDisplayModel(for item: MediaItem) async -> SeriesDisplayModel {
        var tvDetail: SeriesDetail? = nil
        if let tvId = item.id {
            tvDetail = try? await mediaService.fetchSeriesDetail(id: tvId)
        }
        
        let title = tvDetail?.name ?? item.name ?? "Unknown"
        let tagline = tvDetail?.tagline
        let overview = tvDetail?.overview ?? item.overview ?? "No description available"
        let rating = item.voteAverage ?? 0.0
        
        let genres: [String]
        if let detailGenres = tvDetail?.genres, !detailGenres.isEmpty {
            genres = detailGenres.map { $0.name }
        } else {
            genres = item.genreNames(using: GenreManager.shared.genres)
        }
        
        var image: UIImage? = nil
        if let posterPath = item.displayImagePath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            image = try? await imageService.loadImage(from: url)
        }
        
        let ratingText = String(format: "%.1f", rating)
        let ratingColor: UIColor = rating >= 7.0 ? .systemGreen : (rating >= 5.0 ? .systemOrange : .systemRed)
        
        return SeriesDisplayModel(
            title: title,
            tagline: tagline,
            overview: overview,
            ratingText: ratingText,
            ratingColor: ratingColor,
            genres: genres,
            image: image,
            status: tvDetail?.status,
            yearRange: tvDetail?.yearRange,
            seasonEpisodeText: tvDetail?.seasonEpisodeText,
            networkName: tvDetail?.networkNames,
            creatorNames: tvDetail?.creatorNames
        )
    }
    
    func buildPersonDisplayModel(for item: MediaItem) async -> PersonDisplayModel {
        var personDetail: PersonDetail? = nil
        if let personId = item.id {
            personDetail = try? await mediaService.fetchPersonDetail(id: personId)
        }
        
        let name = personDetail?.name ?? item.name ?? "Unknown"
        let biography = personDetail?.biography ?? "No biography available"
        let knownFor = personDetail?.knownForDepartment ?? item.knownForDepartment
        
        var image: UIImage? = nil
        if let profilePath = item.displayImagePath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)") {
            image = try? await imageService.loadImage(from: url)
        }
        
        return PersonDisplayModel(
            name: name,
            biography: biography,
            image: image,
            knownForDepartment: knownFor,
            birthInfo: personDetail?.birthInfo,
            ageText: personDetail?.ageText,
            deathday: personDetail?.formattedDeathday
        )
    }
}
