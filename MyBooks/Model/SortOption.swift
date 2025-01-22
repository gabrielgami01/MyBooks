import Foundation

enum SortOption: String, Identifiable, CaseIterable {
    case title, author, status
    
    var id: Self { self }
}
