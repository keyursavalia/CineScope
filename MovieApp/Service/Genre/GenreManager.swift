import Foundation

final class GenreManager {
    static let shared = GenreManager()
    private let movieService: MovieServiceProtocol
    private let coreDataManager: CoreDataManager
    
    private(set) var genres: [Int: String] = [:]

    init(movieService: MovieServiceProtocol = MovieService(),
         coreDataManager: CoreDataManager = .shared) {
        self.movieService = movieService
        self.coreDataManager = coreDataManager
        self.genres = coreDataManager.fetchGenreDictionary()
    }

    func refreshGenresIfNeeded() async {
        let lastFetch = UserDefaults.standard.object(forKey: "last_genre_fetch_date") as? Date ?? .distantPast
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        // Only fetch if data is older than 7 days OR if we have no local data
        if lastFetch < sevenDaysAgo || genres.isEmpty {
            do {
                let fetchedGenres = try await movieService.fetchGenres()
                coreDataManager.saveGenres(fetchedGenres)
                self.genres = coreDataManager.fetchGenreDictionary()
                print("Genres refreshed from API")
            } catch {
                print("Failed to refresh genres: \(error)")
            }
        }
    }
}
