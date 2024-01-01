import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    
    @Published private var upcomingMovies: [Movie] = []
    @Published private var searchResults: [Movie] = []
    @Published var searchQuery: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var movies: [Movie] {
        if searchQuery.isEmpty {
            return upcomingMovies
        } else {
            return searchResults
        }
    }
    
    init() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { searchQuery in
                NetworkManager.shared.searchMovies(for: searchQuery)
                    .replaceError(with: MovieResponse(results: []))
            }
            .switchToLatest()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    func fetchInitialData() {
        NetworkManager.shared.fetchMovies()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: &$upcomingMovies)
//            .sink { completion in
//                switch completion {
//                    case .finished: ()
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] movies in
//                self?.movies = movies
//            }
//        .store(in: &cancellables)
    }
}
