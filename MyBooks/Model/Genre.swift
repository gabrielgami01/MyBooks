import SwiftUI
import SwiftData

@Model
final class Genre {
    var name: String
    var color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var books: [Book]?
    
    var hexColor: Color {
        Color(hex: self.color) ?? .blue.opacity(0.5)
    }
    
    
}
