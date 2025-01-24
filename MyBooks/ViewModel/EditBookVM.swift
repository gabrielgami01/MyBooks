import SwiftUI
import SwiftData
import PhotosUI

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
    var recommendedBy = ""
    
    var coverPhotoItem: PhotosPickerItem?
    var coverData: Data?
    var coverImage: UIImage? {
        if let coverData, let image = UIImage(data: coverData) {
            return image
        } else {
            return nil
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: book.status)
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
        || coverData != book.bookCover
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
        self.recommendedBy = book.recommendedBy
        self.coverData = book.bookCover
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
        book.recommendedBy = recommendedBy
        book.bookCover = coverData
    }
    
    func convertPhotoItem() async {
        guard let coverPhotoItem else { return }
        
        do {
            if let result = try await coverPhotoItem.loadTransferable(type: Data.self), let image = UIImage(data: result), let data = image.heicData() {
                coverData = data
            } else {
                coverData = nil
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func unselectCover() {
        coverPhotoItem = nil
        coverData = nil
    }
}
