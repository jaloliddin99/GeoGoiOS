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


public struct RideEndSubmitView: View {
    
    let context: ActivityViewContext<FinishOrderAttributes>

    public init(
        context: ActivityViewContext<FinishOrderAttributes>
    ) {
        self.context = context
    }



    @State private var comment: String = ""
    @State private var rating: Int = 4

    
    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    
                    Image("car_comfort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 18)

                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text("you_arrived".localize())
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text(context.state.orderAmount)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                
                Spacer()
                
                VStack{
                    Text(context.state.regNum)
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
            
            Divider()
            
            StarRating(rating: $rating, maxRating: 5) { newRating in
                print("the rating is \(newRating)")
            }
            
            
        }
        .padding(16)
        .background(Color.white.opacity(0.5))
        .cornerRadius(16)
        
        
    }
    
    
}






