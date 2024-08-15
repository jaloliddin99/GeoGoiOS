//
//  HomeScreenDrawer.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 30/06/24.
//

import SwiftUI



struct HomeScreenDrawer: View {
    @Binding var isOpen: Bool
    @Binding var selectedScreen: DestinationScreen?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileImageView()
                .padding(.bottom, 12)
                .padding(.top, 56)
            Divider()
            DrawerItem(title: "My Trips", action: {
                navigate(to: .myTrips)
            })
            Divider()
            DrawerItem(title: "Payment Method", action: {
                navigate(to: .paymentMethod)
            })
            Divider()
            DrawerItem(title: "Favourite Addresses", action: {
                navigate(to: .favouriteAddresses)
            })
            Divider()
            DrawerItem(title: "Loyalty Program", action: {
                navigate(to: .loyaltyProgram)
            })
            Divider()
            DrawerItem(title: "Discount", action: {
                navigate(to: .discount)
            })
            Divider()
            DrawerItem(title: "Settings", action: {
                navigate(to: .settings)
            })
            Divider()
            DrawerItem(title: "News", action: {
                navigate(to: .news)
            })
            Divider()
            DrawerItem(title: "Support", action: {
                navigate(to: .support)
            })
            Divider()
            DrawerItem(title: "About App", action: {
                navigate(to: .aboutApp)
            })
            Spacer()
        }
        .background(Color.white)
        .clipShape(RoundedCorners(topRight: 20, bottomRight: 20))
        .offset(x: isOpen ? 0 : -UIScreen.main.bounds.size.width * 0.75)
        .animation(.easeInOut, value: isOpen)
        .frame(width: UIScreen.main.bounds.size.width * 0.75)
    }
    
    private func navigate(to destination: DestinationScreen) {
        selectedScreen = destination
        withAnimation {
            isOpen = false
        }
        

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


enum DestinationScreen: Hashable {
    case myTrips, paymentMethod, favouriteAddresses, loyaltyProgram, discount, settings, news, support, aboutApp
}
