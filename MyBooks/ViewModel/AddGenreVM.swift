import SwiftUI
import SwiftData

@Observable
final class AddGenreVM {
    var name = ""
    var color = Color.red
    
    func addGenre(modelContext: ModelContext) {
        let newGenre = Genre(name: name, color: color.toHexString()!)
        modelContext.insert(newGenre)
    }
}
