import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.status) private var books: [Book]
    
    @State private var sortOption: SortOption = .title
    @State private var showAddBook: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("SortOption", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text("Sort by \(option.rawValue.capitalized)")
                    }
                }
                .buttonStyle(.bordered)

                BookListView(sortOption: sortOption)
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
        ContentView()
    }
}

#Preview("Empty Books List") {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        ContentView()
    }
}
