import SwiftUI

struct GenresStack: View {
    var genres: [Genre]
        var body: some View {
            HStack {
                ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
                    Text(genre.name)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(genre.hexColor, in: .rect(cornerRadius: 5))
                }
            }
        }
}

#Preview {
    GenresStack(genres: Genre.sampleGenres)
}
