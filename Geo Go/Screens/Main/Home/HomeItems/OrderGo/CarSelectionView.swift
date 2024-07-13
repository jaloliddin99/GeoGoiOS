//
//  CarSelectionView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import SwiftUI
import Lottie

struct CarSelectionView: View {
    let item: ServiceTariff
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment:.top) {
                Image(imageNameForType(item.icon))
                    .resizable()
                    .frame(width: 72, height: 32)
                
                HStack(spacing: 4){
                    Text("+1000")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .frame(maxWidth: 10, maxHeight: 10)
                        .clipShape(Circle())
                        .padding(.trailing, 2)
                    
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.colorAccent)
                .cornerRadius(12)
                
            }
            
            Text("Comfort")
                .font(.system(size: 14))
                .frame(alignment: .leading)
            
            HStack(spacing: 0) {
                LottieEmptyStateView(fileName: "swipe_right")
                    .frame(width: 10, height: 12)
                    .rotationEffect(.degrees(-90))
                
                ProgressView(value: 0.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.main))
                    .frame(width: 20, height: 20)
                    .padding(.leading, 4)
                
                Text("11 000")
                    .font(.system(size: 14))
                    .padding(.leading, 4)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground).opacity(0.7)))
        
    }
    
    private func imageNameForType(_ type: String) -> String {
        switch type {
        case Constants.CAR_PEREGON:
            return "car_peregon"
        case Constants.CAR_TYPE_3, Constants.CAR_KOMFORT:
            return "car_comfort"
        case Constants.CAR_DELIVERY:
            return "car_delivery"
        default:
            return "car_econom"
        }
    }

}


// Example usage in a SwiftUI view
struct CarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CarSelectionView(item: ServiceTariffSample.sampleData.tariffs![3])
    }
}
