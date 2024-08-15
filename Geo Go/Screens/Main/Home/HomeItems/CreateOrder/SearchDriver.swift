//
//  SearchDriver.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 01/08/24.
//

import SwiftUI

struct SearchDriver: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var elapsedTime: Double = 0
    private let maxTime: Double = 5 * 60
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    var body: some View {
        
        ZStack{
            GeometryReader { geometry in
                let width = geometry.size.width
                
                LottieEmptyStateView(fileName: "loading")
                    .frame(width: width * 0.9, height: width * 0.9)
                    .position(x: width / 2, y: geometry.size.height / 2)
                Image("active_location")
                    .frame(width: 30, height: 30)
                    .position(x: width / 2, y: geometry.size.height / 2)
            }
        }
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .cornerRadius(10)
            
            Text("Search Car")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            HStack {
                ProgressView(value: elapsedTime, total: maxTime)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 20)
                Text(formattedTime(elapsedTime))
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.vertical, 12)
            .onReceive(timer) { _ in
                if elapsedTime < maxTime {
                    elapsedTime += 1
                }
            }
            
            let lh = viewModel.locationHolder
            SearchDriverAddress(flagName: "location_pin", locationName: lh[0].addressName)
            
            if lh.count > 1 {
                let name = lh[lh.count-1].addressName
                SearchDriverAddress(flagName: "destination_flag", locationName: name)
            }
            
            Button(action: {
                viewModel.showCancelOrderAlert.toggle()
            }, label: {
                Text("Cancel")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    
            })
            .foregroundColor(.red)
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 1)
            )
            .padding(.bottom, 16)

            
            
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12, corners: [.topLeft, .topRight])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .shadow(radius: 2)
        .ignoresSafeArea()
        
    }
    
    private func formattedTime(_ value: Double) -> String {
        let minutes = Int(value) / 60
        let seconds = Int(value) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}

struct SearchDriverAddress: View {
    let flagName: String
    let locationName: String
    var body: some View {
        HStack(alignment: .bottom){
            Image(flagName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .padding(4)
                .frame(width: 28, height: 28)
                .background(Circle().fill(.main))
            Text(locationName)
                .font(.system(size: 20, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .padding(.bottom, 16)
    }
}
