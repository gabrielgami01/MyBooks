import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
    var status: Status
    
    init(title: String, author: String, dateAdded: Date = .now, dateStarted: Date = .distantPast, dateCompleted: Date = .distantFuture, summary: String = "", rating: Int? = nil, status: Status = .onShelf) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status
    }
    
    var iconName: String {
        switch status {
            case .onShelf:
                "checkmark.diamond.fill"
            case .inProgress:
                "book.fill"
            case .completed:
                "book.vertical.fill"
        }
    }
}

enum Status: String, Codable, Identifiable, CaseIterable {
    case onShelf = "On Shelf"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: Self {
        self
    }
}
