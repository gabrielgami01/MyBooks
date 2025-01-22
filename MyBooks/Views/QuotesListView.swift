import SwiftUI
import SwiftData

struct QuotesListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var quotesVM: QuotesVM
    
    var body: some View {
        VStack {
            GroupBox {
                HStack {
                    LabeledContent("Page") {
                        TextField("page #", text: $quotesVM.page)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                        Spacer()
                    }
                    
                    if quotesVM.selectedQuote != nil {
                        Button {
                            quotesVM.cancelEditing()
                        } label: {
                            Text("Cancel")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button {
                        if quotesVM.selectedQuote != nil {
                            quotesVM.editQuote()
                        } else {
                            quotesVM.addQuote()
                        }
                        quotesVM.cancelEditing()
                    } label: {
                        Text(quotesVM.selectedQuote != nil ? "Update" : "Create")
                    }
                    .buttonStyle(.borderedProminent)
 
                }
                
                TextEditor(text: $quotesVM.text)
                    .frame(height: 150)
                
            }
            
            List {
                ForEach(quotesVM.sortedQuotes) { quote in
                    LazyVStack(alignment: .leading) {
                        Text(quote.creationDate, format: .dateTime.month().day().year())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(quote.text)
                        
                        HStack {
                            Spacer()
                            if let page = quote.page, !page.isEmpty {
                                Text("Page: \(page)")
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        quotesVM.selectedQuote = quote
                        quotesVM.text = quote.text
                        quotesVM.page = quote.page ?? ""
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let quoteID = quotesVM.sortedQuotes[index].id
                        quotesVM.deleteQuote(quoteID: quoteID, modelContext: modelContext)
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
        .navigationTitle("\(quotesVM.book.title) Quotes")
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer(Book.self)) {
        NavigationStack {
            QuotesListView(quotesVM: QuotesVM(book: Book.testBooks[4]))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
