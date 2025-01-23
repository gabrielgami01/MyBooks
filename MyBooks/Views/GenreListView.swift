import SwiftUI
import SwiftData

struct GenreListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Genre.name) private var genres: [Genre]
    
    @State var genresVM: GenresVM
    
    @State private var showAddGenre = false
    
    var body: some View {
        NavigationStack {
            Group {
                if !genres.isEmpty {
                    List {
                        ForEach(genres) { genre in
                            HStack {
                                if let bookGenres = genresVM.book.genres {
                                    Button {
                                        genresVM.addRemove(genre)
                                    } label: {
                                        Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                                    }
                                    .foregroundStyle(genre.hexColor)
                                }
                                
                                Text(genre.name)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                if let bookGenres = genresVM.book.genres,
                                   bookGenres.contains(genres[index]),
                                   let bookGenreIndex = bookGenres.firstIndex(where: {$0.id == genres[index].id}) {
                                    genresVM.removeGenreAtIndex(index: bookGenreIndex)
                                }
                                modelContext.delete(genres[index])                                 
                            }
                        }
                        
                        LabeledContent {
                            Button {
                                showAddGenre.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.medium)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                        } label: {
                            Text("Create new Genre")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView {
                        Image(systemName: "bookmark.fill")
                            .font(.largeTitle)
                    } description: {
                        Text("You need to create some genres first.")
                    } actions: {
                        Button("Create Genre") {
                            showAddGenre.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                }
            }
            .navigationTitle(genresVM.book.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddGenre) {
                AddGenreView()
            }
        }
    }
}

#Preview {
    let genres = Genre.sampleGenres
    let books = Book.testBooks
    books[4].genres = [genres[1], genres[2]] // Agregar género al libro en la posición 4

    return SwiftDataViewer( preview: PreviewContainer(Book.self), items: books + genres) {
        GenreListView(genresVM: GenresVM(book: books[4]))
    }
}
