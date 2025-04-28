//
//  RideTrackingNotificationView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//

import SwiftUI
import CoreLocation
import WidgetKit
import SwiftUI
import ActivityKit
import RideTrackingShared


public struct RideTrackingNotificationView: View {
    
    let context: ActivityViewContext<DriverActivityAttributes>
    
    public init(context: ActivityViewContext<DriverActivityAttributes>) {
        self.context = context
    }
   
    
    public var body: some View {
        
        let (arrivalTime, sliderValue) = context.attributes.calculateProgress(using: context.state)
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    
                    Image("car_comfort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 18)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("arrive_in".localize())
                                .font(.system(size: 18, weight: .bold))
                            Text("\(arrivalTime)")
                                .font(.system(size: 18, weight: .bold))
                            Text("min".localize())
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        HStack (spacing: 4){
                            Text(context.attributes.color)
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.8))
                            Text(context.attributes.model)
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                }
                
                Spacer()
                
                VStack{
                    Text(context.attributes.regNum)
                        .font(.system(size: 15, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(white: 0.85))
                        .cornerRadius(8)
                    
                    Image(imageNameForType(UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 18)
                    
                }
            }
            
           
            HStack(alignment: .center){
                CarProgressSlider(value: sliderValue)
                    .frame(height: 40)
            
                RadioButton(isSelected: true)
                
            }
            
        }
        .padding(16)
        .containerBackground(.white.opacity(0.5), for: .widget)
        .background(Color.white.opacity(0.5))
        .cornerRadius(16)
        
    }
}

struct RadioButton: View {
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 3)
                .frame(width: 18, height: 18)
            
            if isSelected {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 10, height: 10)
            }
        }
    }
}





