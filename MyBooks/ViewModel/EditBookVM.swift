import SwiftUI
import SwiftData

@Observable
final class EditBookVM {
    let book: Book
    
    var title = ""
    var author = ""
    var status = Status.onShelf
    var rating: Int?
    var summary = ""
    var dateAdded = Date.distantPast
    var dateStarted = Date.distantPast
    var dateCompleted = Date.distantPast
    
    var changed: Bool {
        status != Status(rawValue: book.status)
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
    }
            
    
    init(book: Book) {
        self.book = book
        loadBook()
    }
    
    private func loadBook() {
        self.title = book.title
        self.author = book.author
        self.status = Status(rawValue: book.status)!
        self.rating = book.rating
        self.summary = book.summary
        self.dateAdded = book.dateAdded
        self.dateStarted = book.dateStarted
        self.dateCompleted = book.dateCompleted
    }
    
    func updateBook() {
        book.title = title
        book.author = author
        book.status = status.rawValue
        book.rating = rating
        book.summary = summary
        book.dateAdded = dateAdded
        book.dateStarted = dateStarted
        book.dateCompleted = dateCompleted
    }
    
}
