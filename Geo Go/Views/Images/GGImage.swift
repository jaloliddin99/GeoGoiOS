//
//  GGImage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct RemoteImage: View {
    var image: Image?
    let radius: CGFloat
    let imageName: String?
    
    var body: some View {
        (image ?? Image(imageName!))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: radius * 2, height: radius * 2)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}




struct RoundedProfileImage: View {
    let radius: CGFloat
    let name: String
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: radius*2, height: radius*2)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(.purple.opacity(0.5), lineWidth: 10)
            )
            .cornerRadius(radius)
    }
}



