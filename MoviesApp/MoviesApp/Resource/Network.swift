import Foundation
import Combine

enum NetworkingError: Error {
    case invalidURL
}

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
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: jsonDecoder)
    }
    
    func fetchCredits(for movie: Movie) -> some Publisher<MovieCreditsResponse, Error> {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(Constants.API_KEY)") 
        else { return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher() }
                
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieCreditsResponse.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    func fetchReviews(for movie: Movie) -> some Publisher<MovieReviewsResponse, Error> {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=\(Constants.API_KEY)")
        else { return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher() }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieReviewsResponse.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}

