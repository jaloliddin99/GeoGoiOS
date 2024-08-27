//
//  GGImage.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct RemoteRoundedImage: View {
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


struct RemoteImage: View {
    var image: Image?
    let width: CGFloat
    let height: CGFloat
    let imageName: String?
    
    var body: some View {
        (image ?? Image(imageName!))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
}





struct RoundedProfileImage: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        RemoteRoundedImage(image: viewModel.image, radius: 50, imageName: "profile-image")
            .onAppear { viewModel.loadImage(fromURLString: "") }
        
//        Image(name)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: radius*2, height: radius*2)
//            .overlay(
//                RoundedRectangle(cornerRadius: radius)
//                    .stroke(.purple.opacity(0.5), lineWidth: 10)
//            )
//            .cornerRadius(radius)
    }
}



