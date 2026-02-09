import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext { container.viewContext }

    func saveGenres(_ genres: [Genre]) {
        // Clear existing genres first to avoid duplicates
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GenreEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            
            for genre in genres {
                let entity = GenreEntity(context: context)
                entity.id = Int64(genre.id)
                entity.name = genre.name
            }
            try context.save()
            // Store the current date as the last fetch date
            UserDefaults.standard.set(Date(), forKey: "last_genre_fetch_date")
        } catch {
            print("Error saving genres: \(error)")
        }
    }

    func fetchGenreDictionary() -> [Int: String] {
        let request: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.reduce(into: [Int: String]()) { dict, entity in
                dict[Int(entity.id)] = entity.name
            }
        } catch {
            print("Fetch failed")
            return [:]
        }
    }
}
