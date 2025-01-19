import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var addBookVM = AddBookVM()
    
    var body: some View {
        Form {
            TextField("Book Title", text: $addBookVM.title)
            
            TextField("Author", text: $addBookVM.author)
            
            Button {
                if addBookVM.addBook(context: context) {
                    dismiss()
                }
            } label: {
                Text("Create")
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, 5)
            .disabled(addBookVM.title.isEmpty || addBookVM.author.isEmpty)
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
        .alert(addBookVM.alertMsg, isPresented: $addBookVM.showAlert) {}
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        NavigationStack {
            AddBookView()
        }
    }
}
