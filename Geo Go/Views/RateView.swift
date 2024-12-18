//
//  RateView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//
import SwiftUI

struct StarRating: View {
    @Binding var rating: Int // Use an Int for clarity
    let maxRating: Int
    let onRatingChanged: (Int) -> Void
    
    init(rating: Binding<Int>, maxRating: Int, onRatingChanged: @escaping (Int) -> Void) {
        self._rating = rating
        self.maxRating = maxRating
        self.onRatingChanged = onRatingChanged
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(index <= rating ? .yellow : .appGray)
                    .onTapGesture {
                        withAnimation {
                            rating = index
                            onRatingChanged(index)
                        }
                    }
            }
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    @State static var previewRating: Int = 3 // State for testing
    
    static var previews: some View {
        StarRating(rating: $previewRating, maxRating: 5) { newRating in
            print("New rating: \(newRating)")
        }
        .padding()
    }
}
