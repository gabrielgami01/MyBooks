import SwiftUI
import SwiftData
import PhotosUI

struct EditBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State var editBookVM: EditBookVM
    
    @State private var showGenres = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Status")
                Picker("Status", selection: $editBookVM.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.descr)
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
                HStack {
                    PhotosPicker(selection: $editBookVM.coverPhotoItem, matching: .images, photoLibrary: .shared()) {
                        Group {
                            if let coverImage = editBookVM.coverImage {
                                Image(uiImage: coverImage)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .tint(.primary)
                            }
                        }
                        .frame(width: 75, height: 100)
                        .overlay(alignment: .bottomTrailing) {
                            if editBookVM.coverData != nil {
                                Button {
                                    editBookVM.unselectCover()
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                    
                    VStack {
                        LabeledContent {
                            RatingComponent(currentRating: $editBookVM.rating)
                        } label: {
                            Text("Rating")
                        }
                        
                        LabeledContent {
                            TextField("", text: $editBookVM.title)
                        } label: {
                            Text("Title")
                                .foregroundStyle(.secondary)
                        }
                        
                        LabeledContent {
                            TextField("", text: $editBookVM.author)
                        } label: {
                            Text("Author")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                LabeledContent {
                    TextField("", text: $editBookVM.recommendedBy)
                } label: {
                    Text("Recommended by")
                        .foregroundStyle(.secondary)
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
            
            if let genres = editBookVM.book.genres {
                ViewThatFits {
                    GenresStack(genres: genres)
                    
                    ScrollView(.horizontal) {
                        GenresStack(genres: genres)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            
            HStack {
                Button {
                    showGenres.toggle()
                } label: {
                    Label("Genres", systemImage: "bookmark.fill")
                }
                
                NavigationLink {
                    QuotesListView(quotesVM: QuotesVM(book: editBookVM.book))
                } label: {
                    let count = editBookVM.book.quotes?.count ?? 0
                    Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
                            
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
        .sheet(isPresented: $showGenres) {
            GenreListView(genresVM: GenresVM(book: editBookVM.book))
        }
        .task(id: editBookVM.coverPhotoItem) {
            await editBookVM.convertPhotoItem()
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
