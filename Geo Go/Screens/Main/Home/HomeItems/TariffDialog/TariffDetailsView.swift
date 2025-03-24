//
//  TariffDetailsView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 08/08/24.
//

import SwiftUI

struct TariffDetailsView: View {
    let item: ServiceTariff
    

    var body: some View {
        
        let desc = description(lang: DataHolder.lang, data: item)
        ScrollView(showsIndicators: false){
            VStack(spacing: 12){
                HStack{
                    Text(convertTariff(lang: DataHolder.lang, data: item))
                        .font(.system(size: 24, weight: .bold))
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    if item.costChangeStep ?? 0.0 > 0.0 {
                        LottieEmptyStateView(fileName: "swipe_right")
                            .frame(width: 16, height: 20)
                            .rotationEffect(.degrees(-90))
                        
                        Text(formatNumberWithSpaces(item.costChangeStep ?? 0))
                            .font(.system(size: 20, weight: .medium))
                            .frame(alignment: .leading)
                    }
                }
                
                Divider()
                
                Text(desc.title)
                    .font(.system(size: 18, weight: .regular))
                    .lineSpacing(4)
                
                let width = UIScreen.main.bounds.size.width - 32
                Image(imageNameForType(item.icon))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width/2.4)
                
                
                
                
                HStack{
                    Image("menu_icon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    VStack(spacing: 2){
                        Text(desc.bonusFirst)
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(desc.returnBonus)
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black.opacity(0.5))
                    }
                    Spacer()
                    
                }
                Divider()
                    .padding(.top, 8)
                
                
                if item.costChangeStep ?? 0.0 > 0.0 && (item.Type == "add" || item.Type == "multiply" ) {
                    HStack{
                        LottieEmptyStateView(fileName: "swipe_right")
                            .padding(.horizontal, 4)
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2){
                            Text("tariff_reduced".localize())
                                .font(.system(size: 14, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("tariff_increased".localize())
                                .font(.system(size: 14, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.black.opacity(0.5))
                        }
                        Spacer()
                        
                    }
                }
                
                
                
                if let description = item.description {
                    Text("about_tariff".localize())
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    let tariffDetails = titleConvertor(stringItem: description, lang: DataHolder.lang)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(tariffDetails) { tariff in
                                TariffInfoItem(tariffDetails: tariff)
                            }
                        }
                        .frame(height: 200)
                    }
                }
                DiscountView()
            }
            .padding(16)
           
        }
    
    }
}

struct TariffInfoItem: View {
    let tariffDetails: TariffDetails
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Image("info")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
    
            Text(tariffDetails.titleDetails)
                .font(.system(size: 20, weight: .semibold))
            
            Text(tariffDetails.descriptionDetails)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
        .padding(12)
        .frame(width: 150, height: 200)
        .background(Color.colorHover)
        .cornerRadius(12)
        
    }
}

struct DiscountView: View {
    var body: some View {
        Text("discount".localize())
            .font(.system(size: 24, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
        
        VStack(spacing: 20){
            Text("enter_promo_code_if_have".localize())
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            
            Button(action: {
                
            }, label: {
                GGButton(title: "add_promo_code")
            })
            .frame(height: 50)
        }
        .cornerRadius(12)
        .padding(16)
        .frame(maxWidth: .infinity)
        
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black.opacity(0.6), lineWidth: 1)
        )
        .padding(.bottom, 16)
        
       
    }
}


//
//#Preview {
//    TariffInfoItem(tariffDetails: TariffDetails(titleDetails: "Inside City", descriptionDetails: "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"))
//        .previewLayout(.sizeThatFits)
//}
//#Preview {
//    TariffDetailsView(item: ServiceTariffSample.sampleData.tariffs![1])
//        .previewLayout(.sizeThatFits)
//}
