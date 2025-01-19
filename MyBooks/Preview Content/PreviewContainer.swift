import SwiftData

@MainActor
struct PreviewContainer {
    let container: ModelContainer!
    
    init(_ types: any PersistentModel.Type..., isStoredInMemoryOnly: Bool = true) {
        let schema = Schema(types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        
        do {
            self.container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the preview container")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        examples.forEach { example in
            self.container.mainContext.insert(example)
        }
    }
}

