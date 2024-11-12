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
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileImageView(viewModel: viewModel)
                .padding(.bottom, 12)
                .padding(.top, 56)
                .onTapGesture {
                    navigate(to: .profile)
                }
            
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
            DrawerItem(title: "Discount", action: {
                navigate(to: .discount)
            })
           
            Divider()
            DrawerItem(title: "News", action: {
                navigate(to: .news)
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
//        withAnimation {
//            isOpen = false
//        }
        

    }
}

func ProfileImageView(viewModel: MainViewModel) -> some View{
    VStack(alignment: .center){
        let baseUrl = UserDefaults.standard.value(forKey: Constants.baseUrl)!
        let userName = UserDefaults.standard.string(forKey: Constants.USER_NAME)!
        let url = "\(baseUrl)/bosh/get_photo.php?type=client&phone="
        let finalUrl = "\(url)\(getUserPhone())"
        
        HStack{
            Spacer()
            RemoteRoundedImage(image: viewModel.image, radius: 40, imageName: "profile-image")
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 54)
                        .stroke(.main, lineWidth: 2)
                )
                .onAppear { viewModel.loadImage(fromURLString: finalUrl) }
            
            Spacer()
        }
        
        Text(userName)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black)
        
        Text("+\(getUserPhone())")
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
    case myTrips, paymentMethod, favouriteAddresses, discount, profile, news, aboutApp
}
