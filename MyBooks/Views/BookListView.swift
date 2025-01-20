import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]
    
    @State private var showAddBook: Bool = false
    
    var body: some View {
        NavigationStack {
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

                } else {
                    ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
                }
            }
            .navigationTitle("MyBooks")
            .toolbar {
                ToolbarItem {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                                                .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView()
                    .presentationDetents([.medium])
            }
            .navigationDestination(for: Book.self) { book in
                EditBookView(editBookVM: EditBookVM(book: book))
            }
        }
    }
}

#Preview("Books List") {
    SwiftDataViewer(preview: PreviewContainer(Book.self), items: Book.testBooks) {
        BookListView()
    }
}

#Preview("Empty Books List") {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        BookListView()
    }
}
