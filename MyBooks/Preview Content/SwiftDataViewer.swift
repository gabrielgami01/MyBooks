import SwiftUI
import SwiftData

struct SwiftDataViewer<Content: View>: View {
    private let content: Content
    private let preview: PreviewContainer
    private let items: [any PersistentModel]?
    
    init(preview: PreviewContainer, items: [any PersistentModel]? = nil, @ViewBuilder _ content: () -> Content) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    
    var body: some View {
        content
            .modelContainer(preview.container)
            .onAppear {
                if let items {
                    preview.addExamples(items)
                }
            }
    }
}
