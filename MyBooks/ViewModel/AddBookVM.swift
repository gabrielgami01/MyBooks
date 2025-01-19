import SwiftUI
import SwiftData

@Observable
final class AddBookVM {
    var title = ""
    var author = ""
    
    var showAlert = false
    var alertMsg = ""
    
    func addBook(context: ModelContext) -> Bool {
        let query = FetchDescriptor<Book>(predicate: #Predicate { $0.title == title && $0.author == author})
        do {
            if let _ = try context.fetch(query).first {
                alertMsg = "Book already exists"
                showAlert = true
                return false
            } else {
                let newBook = Book(title: title, author: author)
                context.insert(newBook)
                return true
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
