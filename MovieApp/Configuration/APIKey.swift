import Foundation

enum APIKey {
    static var accessToken: String {
        guard let path = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let token = plist["TMDB_API_TOKEN"] as? String else {
            fatalError("APIKey.plist not found. Please create Configuration/APIKey.plist with your TMDB_API_TOKEN.")
        }
        return "Bearer \(token)"
    }
}
