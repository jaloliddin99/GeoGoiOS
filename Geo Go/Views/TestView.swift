//
//  TestView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct EditBtn: View {
    var body: some View {
        Image(systemName: "pencil")
            .frame(width: 32, height: 32)
            .background(Circle().fill(.main))
            .foregroundColor(.white)
    }
}

#Preview {
    EditBtn()
}


struct WhatsUpView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12){
                HStack(spacing: 12) {
                    CardView(imageName: "image_1", title: "whats_up", textColor: .white, width: 150, imageNumber:1)
                    
                    
                    CardView(imageName: "image_2", title: "choosing_comfort", textColor: .white, width: geometry.size.width-162, imageNumber: 2)
                }
                
                CardView(imageName: "image_3", title: "how_to_check_d", textColor: .white, width: geometry.size.width,
                         imageNumber: 2)
                
                HStack(spacing: 12) {
                    FrameView(imageName: "image_4", title: "why_prices_increased", textColor: .black, width: geometry.size.width-162, bgColor: .colorWs1)
                    
                    FrameView(imageName: "image_5", title: "parcel_delivery", textColor: .black, width: 150, bgColor: .colorWs2)
                    
                }
                
                FrameView(imageName: "image_6", title: "why_card_better", textColor: .black, isCustomImage: true, width: geometry.size.width, bgColor: .colorWs3)
            }
            
        }
        .frame(height: 150)
        
    }
}

struct CardView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var width: CGFloat
    var imageNumber = 1
    
    var body: some View {
        ZStack {
            if imageNumber == 1 {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }else{
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: width, maxHeight: 135)
            }
            
            
            VStack {
                HStack {
                    Text(LocalizedStringKey(title))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(textColor)
                        .padding()
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .background(.colorWs0)
        .cornerRadius(16)
        .frame(height: 135)
    }
}


struct FrameView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var isCustomImage: Bool = false
    var maxLines: Int = 2
    let width: CGFloat
    let bgColor: Color
    var body: some View {
        ZStack {
            bgColor
                .edgesIgnoringSafeArea(.all)

            Text(LocalizedStringKey(title))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
                .lineLimit(maxLines)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            
            
            
            if isCustomImage {
                Image(imageName)
                    .resizable()
                    .frame(width: 120, height: 90)
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            }else{
                Image(imageName)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            }
                
            
        }
        .frame(height: 135)
        .background(bgColor)
        .cornerRadius(16)
        
       
    }
}

struct WhatsUpView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsUpView()
            
    }
}
