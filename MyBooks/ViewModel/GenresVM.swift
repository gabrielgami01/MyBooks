import SwiftUI
import SwiftData

@Observable
final class GenresVM {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    func addRemove(_ genre: Genre) {
        if let bookGenres = book.genres {
            if bookGenres.isEmpty {
                book.genres?.append(genre)
            } else {
                if bookGenres.contains(genre),
                   let index = bookGenres.firstIndex(where: {$0.id == genre.id}) {
                    book.genres?.remove(at: index)
                } else {
                    book.genres?.append(genre)
                }
            }
        }
    }
    
    func removeGenreAtIndex(index: Int) {
        book.genres?.remove(at: index)
    }
            
}
