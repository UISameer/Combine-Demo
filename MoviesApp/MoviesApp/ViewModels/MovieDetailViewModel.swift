import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    
    let movie: Movie
    private var cancellables = Set<AnyCancellable>()
    @Published var data: (credits: [MovieCastMember], reviews: [MovieReview]) = ([], [])
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchData() {
        let creditsPublisher = NetworkManager.shared
            .fetchCredits(for: movie).map(\.cast)
            .replaceError(with: [])
        let reviewsPublisher = NetworkManager.shared
            .fetchReviews(for: movie).map(\.results)
            .replaceError(with: [])
        
        Publishers.Zip(creditsPublisher, reviewsPublisher)
            .receive(on: DispatchQueue.main)
            .map{ (credits: $0.0, reviews: $0.1) }
//            .assign(to: &$data)
            .sink { [weak self] data in
                self?.data = data
            }
            .store(in: &cancellables)
    }
}
