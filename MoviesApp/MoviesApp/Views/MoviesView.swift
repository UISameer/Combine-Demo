import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel = MoviesViewModel()
    var body: some View {
        NavigationStack {
            List(viewModel.movies) { movie in
                NavigationLink {
                    MovieDetailView(movie: movie)
                } label: {
                    HStack {
                        AsyncImage(url: movie.posterURL) { poster in
                            poster
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.overview)
                                .font(.caption)
                                .lineLimit(3)
                        }
                    }
                }
            }
            .navigationTitle("Upcoming Movies")
        }
        .searchable(text: $viewModel.searchQuery)
        .onAppear {
            viewModel.fetchInitialData()
        }
    }
}

#Preview {
    MoviesView()
}
