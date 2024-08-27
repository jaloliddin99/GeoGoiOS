//
//  MarkerView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import Foundation
import SwiftUI
import Lottie


struct MarkerView: View {
    
    @Binding var markerOffset: CGFloat
    @ObservedObject var viewModel: MainViewModel

    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            MainMarkerBox(markerOffset: $markerOffset, viewModel: viewModel)
                .background(Color.blue)
                .cornerRadius(12)
                .frame(maxHeight: 56)
                .padding(.leading, 24)
                .padding(.trailing, 24)
            
            Rectangle()
                .frame(width: 2.4, height: 28)
                .background(Color.black)
                .cornerRadius(1.2, corners: [.bottomLeft, .bottomRight])
        }
    }
}

struct MainMarkerBox: View {
    @Binding var markerOffset: CGFloat
    @ObservedObject var viewModel: MainViewModel


    var body: some View {
        HStack(alignment: .center) {
            ZStack{
                let isShowingMarker: Double = markerOffset.isEqual(to: 0) ? 1 : 0
                let isShowingLottie: Double = markerOffset.isEqual(to: 0) ? 0 : 1
                MinuteTextView()
                    .opacity(isShowingMarker)
                LottieEmptyStateView(fileName: "marker_location")
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(4)
                    .opacity(isShowingLottie)
            }
            
            AddressView(viewModel: viewModel)
                .padding(.leading, 12)
                .padding(.trailing, 12)
        }
        .background(.main)
      
    }
}

struct MinuteTextView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Text("5")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.main)
            Text("min")
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.main)
        }
        .frame(maxWidth: 48, maxHeight: 48)
        .background(Color.white)
        .cornerRadius(12)
        .padding(4)
        
    }
}

struct AddressView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        let name = viewModel.currentAddress?.display_name ?? "Point on the map"
        Text(name)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .lineLimit(1)
            
    }
}

struct LottieEmptyStateView: UIViewRepresentable {
    var fileName: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: UIViewRepresentableContext<LottieEmptyStateView>) -> some UIView {
        
        let view = UIView(frame: .zero)
        let lottieAnimationView = LottieAnimationView(name: fileName, bundle: Bundle.main)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = loopMode
        lottieAnimationView.play()
        
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieAnimationView)
        
        NSLayoutConstraint.activate([
            lottieAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieEmptyStateView>) {
        
    }
}




