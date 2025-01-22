import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    
    init(sortOption: SortOption) {
        let sortDescriptor: [SortDescriptor<Book>] = switch sortOption {
            case .title:
                [SortDescriptor(\Book.title)]
            case .author:
                [SortDescriptor(\Book.author)]
            case .status:
                [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        }
        _books = Query(sort: sortDescriptor)
    }
    
    var body: some View {
        Group {
            if !books.isEmpty {
                List {
                    ForEach(books) { book in
                        NavigationLink(value: book) {
                            HStack(alignment: .firstTextBaseline, spacing: 20) {
                                Image(systemName: book.iconName)
                                    .imageScale(.large)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.title2)
                                    
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                    
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(0..<rating, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
            }
        }
    }
}

#Preview("Books List") {
    SwiftDataViewer(preview: PreviewContainer(Book.self), items: Book.testBooks) {
        BookListView(sortOption: .status)
    }
}
