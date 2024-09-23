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
        VStack(spacing: 12) {
            Rectangle()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .cornerRadius(10)
            
            Text("Searching Car...")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 4)
            
            HStack {
                ProgressView(value: elapsedTime, total: maxTime)
                    .progressViewStyle(LinearProgressViewStyle(tint: .main))
                    .frame(height: 20)
                
                Text(formattedTime(elapsedTime))
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .frame(width: 80, alignment: .trailing)
                    .foregroundColor(.main)
            }
            .onReceive(timer) { _ in
                if elapsedTime < maxTime {
                    elapsedTime += 1
                }
            }
            
            let lh = viewModel.locationHolder
            
            AddressFieldStatic(mainViewModel: viewModel)

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
        .background(.white)
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


struct AddressFieldStatic: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        HStack(alignment: .center,spacing: 8) {
            Image("route_image")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 64)
            
            VStack(spacing: 12) {
                if !mainViewModel.locationHolder.isEmpty {
                    Text(mainViewModel.locationHolder[0].addressName)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                
                Divider()
                
                HStack{
                    let count = mainViewModel.locationHolder.count
                    if count == 1{
                        Text("Destination is not entered!")
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.5))
                        
                    }else if count >= 2 {
                        Text(mainViewModel.locationHolder[count-1].addressName)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundColor(.txt)
                        
                    }else  {
                        Text("Error Occured")
                            .fontWeight(.medium)
                            .foregroundColor(.txt)
                            .lineLimit(1)
                    }
                    Spacer()
                }
            }
            
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
    }
}


