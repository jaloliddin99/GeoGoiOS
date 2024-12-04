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
    
    @ObservedObject var viewModel: MainViewModel

    
    var body: some View {
        let height = viewModel.orderGoViewHeight
        VStack(alignment: .center, spacing: 0) {
            MainMarkerBox(viewModel: viewModel)
                .background(Color.blue)
                .cornerRadius(12)
                .frame(maxHeight: 56)
                .padding(.horizontal, 24)
               
            Rectangle()
                .frame(width: 2.4, height: 28)
                .background(Color.black)
                .cornerRadius(1.2, corners: [.bottomLeft, .bottomRight])
        }
        
        .padding(.bottom, viewModel.status > 0 ? height : 0)
        .animation(.easeInOut(duration: 0.4), value: viewModel.status)

    }
}

struct MainMarkerBox: View {
    @ObservedObject var viewModel: MainViewModel


    var body: some View {
        HStack(alignment: .center) {
            ZStack{
                let isShowingMarker: Double = viewModel.markerOffset.isEqual(to: 0) ? 1 : 0
                let isShowingLottie: Double = viewModel.markerOffset.isEqual(to: 0) ? 0 : 1
                MinuteTextView()
                    .opacity(isShowingMarker)
                LottieEmptyStateView(fileName: "marker_location")
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(4)
                    .opacity(isShowingLottie)
            }
            
            AddressView(viewModel: viewModel, markerOffset: $viewModel.markerOffset)
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
    @Binding var markerOffset: CGFloat

    var body: some View {
        let name = markerOffset != 0 ? "searching_with_dot" :
        (viewModel.locationHolder.isEmpty ? "point_on_map" : viewModel.locationHolder[0].addressName)
        Text(LocalizedStringKey(name))
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
