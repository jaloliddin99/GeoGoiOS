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
        ZStack {
            LottieEmptyStateView(fileName: "search_car")
                .frame(width: UIScreen.main.bounds.width - 24, height: UIScreen.main.bounds.width - 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Image("client_flag2")
                .resizable()
                .frame(width: 80, height: 80)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack {
                displayBottomView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
                        
        }
        .ignoresSafeArea()
    }
    
    private func displayBottomView() -> some View {
        VStack(spacing: 12) {
            Rectangle()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .cornerRadius(10)
            
            Text("searching_car_dot")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 4)
            
            HStack {
                ProgressView(value: elapsedTime, total: maxTime)
                    .progressViewStyle(LinearProgressViewStyle(tint: .main))
                    .frame(height: 20)
                
                Text(formattedTime(elapsedTime))
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .frame(width: 80, alignment: .trailing)
                    .foregroundColor(.txt)
            }
            .onReceive(timer) { _ in
                if elapsedTime < maxTime {
                    elapsedTime += 1
                }
            }
            
            AddressFieldStatic(mainViewModel: viewModel)
            
            Button(action: {
                viewModel.showCancelOrderAlert.toggle()
            }, label: {
                Text("cancel_order".localized.capitalizeFirstLetter())
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: 56)
            })
            .foregroundColor(.red)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.red, lineWidth: 1)
            )
            .background(.white)
            .padding(.bottom, 16)



            
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12, corners: [.topLeft, .topRight])
        .shadow(radius: 2)
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
        
        if mainViewModel.locationHolder.count == 1 {
            HStack(alignment: .center,spacing: 8) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.main)

                
                if !mainViewModel.locationHolder.isEmpty {
                    Text(mainViewModel.locationHolder[0].addressName)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground).opacity(0.7))
            )
        }else {
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
                        if count > 1 {
                            Text(mainViewModel.locationHolder[count-1].addressName)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .foregroundColor(.txt)
                        }else  {
                            Text("error_occurred")
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
}


