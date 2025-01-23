import SwiftUI
import SwiftData

struct AddGenreView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var genresVM = AddGenreVM()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $genresVM.name)
                
                ColorPicker("Set the genre color", selection: $genresVM.color, supportsOpacity: false)
                
                Button {
                    genresVM.addGenre(modelContext: modelContext)
                    dismiss()
                } label: {
                    Text("Create")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(genresVM.name.isEmpty)
            }
            .padding()
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
            
}

#Preview {
    AddGenreView()
}
