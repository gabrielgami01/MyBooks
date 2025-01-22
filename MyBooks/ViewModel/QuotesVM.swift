import SwiftData
import SwiftUI

@Observable
final class QuotesVM {
    let book: Book
    
    var page = ""
    var text = ""
    
    var selectedQuote: Quote? = nil
    
    var sortedQuotes: [Quote] {
        book.quotes?.sorted { $0.creationDate < $1.creationDate } ?? []
    }
    
    init(book: Book) {
        self.book = book
    }

    func addQuote() {
        let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
        book.quotes?.append(quote)
    }
    
    func editQuote() {
        selectedQuote?.text = text
        selectedQuote?.page = page
    }
    
    func deleteQuote(quoteID: UUID, modelContext: ModelContext) {
        if let quote = book.quotes?.first(where: { $0.id == quoteID }) {
            modelContext.delete(quote)
        }
    }
    
    func cancelEditing() {
        page = ""
        text = ""
        selectedQuote = nil
    }
}
