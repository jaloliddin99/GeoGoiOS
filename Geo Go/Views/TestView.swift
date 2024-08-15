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
        VStack {
            GeometryReader { geometry in
                HStack(spacing: 12) {
                    CardView(imageName: "image_1", title: "What's up?", textColor: .black, width: 150)
                    
                    CardView(imageName: "image_2", title: "Choosing Comfort", textColor: .white, width: geometry.size.width-162)
                }
            }
            .frame(height: 150)
            
            
            GeometryReader { geometry in
                CardView(imageName: "image_3", title: "How we check \ndrivers", textColor: .white, maxLines: 2, width: geometry.size.width)
            }
            .frame(height: 150)
           
                
            
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    FrameView(imageName: "image_4", title: "Why the prices \nincreased?", textColor: .black, isCard: true, width: geometry.size.width-162, bgImage: "card_1")
                    
                    FrameView(imageName: "image_5", title: "Delivery of parcels", textColor: .black, isCard: false, width: 150, bgImage: "card_5")
                }
            }
            .frame(height: 150)
           
            GeometryReader { geometry in
                FrameView(imageName: "image_6", title: "How is the card better than cash", textColor: .black, isCard: true, width: geometry.size.width, bgImage: "card_6")
            }
            .frame(height: 150)
           
              
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

struct CardView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var maxLines: Int = 1
    var width: CGFloat
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(16)
                .frame(maxWidth: width, maxHeight: 150)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(textColor)
                        .lineLimit(maxLines)
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .cornerRadius(16)
        .frame(height: 150)
    }
}


struct FrameView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var isCard: Bool
    var maxLines: Int = 2
    let width: CGFloat
    let bgImage: String
    var body: some View {
        ZStack {
            Image(bgImage)
                .resizable()
                .scaledToFill()
                .cornerRadius(16)
                .frame(maxWidth: width, maxHeight: 150)
            
            VStack {
                HStack {
                    Text(title)
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(textColor)
                        .lineLimit(maxLines)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                
                Spacer()
                
                if !isCard {
                    Image(imageName)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                    
                    Spacer()
                } else {
                    Spacer()
                    HStack{
                        Spacer()
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            
                            
                    }
                        
                }
            }
        }
        .cornerRadius(16)
        .frame(height: 150)
       
    }
}

struct WhatsUpView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsUpView()
            
    }
}
