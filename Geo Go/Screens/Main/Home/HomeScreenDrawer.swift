//
//  HomeScreenDrawer.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import SwiftUI



struct HomeScreenDrawer: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileImageView()
                .padding(.bottom, 12)
                .padding(.top, 56)
            Divider()
            DrawerItem(title: "My Trips", action: { print("My Trips clicked") })
            Divider()
            DrawerItem(title: "Payment Method", action: { print("Payment Method clicked") })
            Divider()
            DrawerItem(title: "Favourite Addresses", action: { print("Favourite Addresses clicked") })
            Divider()
            DrawerItem(title: "Loyalty Program", action: { print("Loyalty Program clicked") })
            Divider()
            DrawerItem(title: "Discount", action: { print("Discount clicked") })
            Divider()
            DrawerItem(title: "Settings", action: { print("Settings clicked") })
            Divider()
            DrawerItem(title: "News", action: { print("News clicked") })
            Divider()
            DrawerItem(title: "Support", action: { print("Support clicked") })
            Divider()
            DrawerItem(title: "About App", action: { print("About App clicked") })
            Spacer()
            
            
        }
        
        .background(Color.white)
        .clipShape(RoundedCorners(topRight: 20, bottomRight: 20))
        .offset(x: isOpen ? 0 : -UIScreen.main.bounds.size.width*0.75)
        .animation(.easeInOut, value: isOpen)
        .frame(width: UIScreen.main.bounds.size.width*0.75)
        
        
    }
}

func ProfileImageView() -> some View{
    VStack(alignment: .center){
        HStack{
            Spacer()
            Image("profile-image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.purple.opacity(0.5), lineWidth: 10)
                )
                .cornerRadius(50)
            Spacer()
        }
        
        Text("Sadulla Soatov")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black)
        
        Text("IOS Developer")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.black.opacity(0.5))
    }
}

struct DrawerItem: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
        }
        .frame(height: 56)
        .contentShape(Rectangle())
        .padding(0)
    }
}
