import SwiftUI
import SwiftData

struct EditBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State var editBookVM: EditBookVM
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Status")
                Picker("Status", selection: $editBookVM.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                }
                .buttonStyle(.bordered)
            }
            
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $editBookVM.dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                if editBookVM.status == .inProgress || editBookVM.status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $editBookVM.dateStarted, in: editBookVM.dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                if editBookVM.status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $editBookVM.dateCompleted, in: editBookVM.dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: editBookVM.status) { oldValue, newValue in
                if newValue == .onShelf {
                    editBookVM.dateStarted = .distantPast
                    editBookVM.dateCompleted = .distantPast
                } else if newValue == .inProgress && oldValue == .completed {
                    // from completed to inProgress
                    editBookVM.dateCompleted = .distantPast
                } else if newValue == .inProgress && oldValue == .onShelf {
                    // Book has been started
                    editBookVM.dateStarted = .now
                } else if newValue == .completed && oldValue == .onShelf {
                    // Forgot to start book
                    editBookVM.dateCompleted = .now
                    editBookVM.dateStarted = editBookVM.dateAdded
                } else {
                    // completed
                    editBookVM.dateCompleted = .now
                }
            }
            
            Divider()
            
            VStack {
                LabeledContent {
                    RatingComponent(currentRating: $editBookVM.rating)
                } label: {
                    Text("Rating")
                }
                
                LabeledContent {
                    TextField("", text: $editBookVM.title)
                } label: {
                    Text("Title").foregroundStyle(.secondary)
                }
                
                LabeledContent {
                    TextField("", text: $editBookVM.author)
                } label: {
                    Text("Author").foregroundStyle(.secondary)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Summary").foregroundStyle(.secondary)
                
                TextEditor(text: $editBookVM.summary)
                    .padding(5)
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.tertiary, lineWidth: 1)
                    }
            }
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem {
                Button {
                    editBookVM.updateBook()
                    dismiss()
                } label: {
                    Text("Update")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!editBookVM.changed)
            }
        }
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        NavigationStack {
            EditBookView(editBookVM: EditBookVM(book: .testBooks[2]))
        }
    }
}
