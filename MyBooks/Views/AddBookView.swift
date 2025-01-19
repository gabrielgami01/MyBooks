import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    
    var body: some View {
        Form {
            TextField("Book Title", text: $title)
            
            TextField("Author", text: $author)
            
            Button {
                let newBook = Book(title: title, author: author)
                context.insert(newBook)
                dismiss()
            } label: {
                Text("Create")
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, 5)
            .disabled(title.isEmpty || author.isEmpty)
        }
        .navigationTitle("New Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                  dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
                        
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        NavigationStack {
            AddBookView()
        }
    }
}
