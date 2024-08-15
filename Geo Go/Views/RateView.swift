//
//  RateView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct StarRating: View {
    struct ClipShape: Shape {
        let width: Double
        
        func path(in rect: CGRect) -> Path {
            Path(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
        }
    }
    
    @Binding var rating: Double
    let maxRating: Int
    let onRatingChanged: (Int) -> Void // Closure to handle star clicks
    
    init(rating: Binding<Double>, maxRating: Int, onRatingChanged: @escaping (Int) -> Void) {
        self.maxRating = maxRating
        self._rating = rating
        self.onRatingChanged = onRatingChanged
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { index in
                Text(Image(systemName: "star"))
                    .frame(width: 50, height: 50)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture {
                        rating = Double(index + 1)
                        onRatingChanged(index + 1)
                    }
            }
        }.overlay(
            GeometryReader { reader in
                HStack(spacing: 0) {
                    ForEach(0..<maxRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .frame(width: 50, height: 50)
                            .font(.system(size: 40))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.yellow)

                    }
                }
                .clipShape(
                    ClipShape(width: (reader.size.width / CGFloat(maxRating)) * CGFloat(rating))
                )
            }
        )
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(rating: .constant(5), maxRating: 5) { newRating in
            print("New rating: \(newRating)")
        }
        .font(.title2)
    }
}
