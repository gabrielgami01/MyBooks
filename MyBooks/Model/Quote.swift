import Foundation
import SwiftData

@Model
final class Quote {
    @Attribute(.unique) var id: UUID = UUID()
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
