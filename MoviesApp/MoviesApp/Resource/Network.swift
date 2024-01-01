import Foundation
import Combine

class NetworkManager {
   
    static let shared = NetworkManager()
    
    private init() {
    }
    
    func fetchMovies() -> some Publisher<MovieResponse, Error> {
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.API_KEY)")!
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data) 
            .decode(type: MovieResponse.self, decoder: jsonDecoder)
    }
    
    func searchMovies(for query: String) -> some Publisher<MovieResponse, Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.API_KEY)&query=\(encodedQuery!)")!
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieResponse.self, decoder: jsonDecoder)
    }
}

