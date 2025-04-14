//
//  AppNotWorkScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/04/25.
//



import SwiftUI
import Combine

struct AppNotWorkScreen: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        ZStack{
            DrawerAndBonusButton(viewModel: viewModel)
                .offset(y: viewModel.markerOffset != 0 ? -200 : 0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.markerOffset)

           
            VStack{
                Spacer()
                LocationButton(viewModel: viewModel, paddingBottom: 12)
                VStack(spacing: 20) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: NSLocalizedString("service_not_supported", comment: "Service not supported message"), viewModel.locationHolder.isEmpty ? "point_on_map".localize() : viewModel.locationHolder[0].addressName))
                                .font(.title3)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                                .fontWeight(.bold)
                            
                            Text("try_different_address".localize())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        
                    }) {
                        Text("enter_address".localize())
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    
                }
                .padding(.top, 20)
                .background(Color.white)
                .cornerRadius(16, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea()
            .offset(y: viewModel.markerOffset != 0 ? 200 : 0)
            .animation(.easeInOut(duration: 0.2), value: viewModel.markerOffset)

            
        }
        

       
    }
}
