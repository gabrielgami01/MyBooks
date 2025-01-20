import SwiftUI

struct RatingComponent: View {
    @Binding var currentRating: Int?
    
    let maxRating = 5

    var body: some View {
        HStack(spacing: 5) {
                Image(systemName: "star")
                    .imageScale(.medium)
                    .symbolVariant(.slash)
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        withAnimation{
                            currentRating = nil
                        }
                    }
                    .opacity(currentRating == 0 ? 0 : 1)
            
            ForEach(1...maxRating, id: \.self) { number in
                image(for: number)
                    .imageScale(.medium)
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        withAnimation{
                            currentRating = number
                        }
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        Image(systemName: number > currentRating ?? 0 ? "star" : "star.fill")
    }
}

#Preview {
    RatingComponent(currentRating: .constant(3))
}
