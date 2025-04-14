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
        VStack(alignment: .leading, spacing: 12) {
            ProfileImageView(viewModel: viewModel)
                .padding(.bottom, 12)
                .padding(.top, 56)
                
            Divider()
            DrawerItem(title: Text("txt_profile".localize()), systemImageName: "person.circle", action: {
                navigate(to: .profile)
            })
            
            DrawerItem(title: Text("drawer_item_my_trips".localize()), systemImageName: "car.fill", action: {
                navigate(to: .myTrips)
            })
            
            DrawerItem(title: Text("drawer_item_payment_method".localize()), systemImageName: "creditcard.fill", action: {
                navigate(to: .paymentMethod)
            })
            
            DrawerItem(title: Text("drawer_item_discount".localize()), systemImageName: "tag.fill", action: {
                navigate(to: .discount)
            })
            
            DrawerItem(title: Text("drawer_item_news".localize()), systemImageName: "newspaper.fill", action: {
                navigate(to: .news)
            })
            
            DrawerItem(title: Text("drawer_item_about_app".localize()), systemImageName: "info.circle.fill", action: {
                navigate(to: .aboutApp)
            })
            
            Spacer()


        }
        .background(Color.white)
        .clipShape(RoundedCorners(topRight: 20, bottomRight: 20))
        .offset(x: isOpen ? 0 : -UIScreen.main.bounds.size.width * 0.85)
        .animation(.easeInOut, value: isOpen)
        .frame(width: UIScreen.main.bounds.size.width * 0.85)
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
    var title: Text
    var systemImageName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImageName)
                    .foregroundColor(.main)
                    .frame(width: 24, height: 24)
                title
                    .foregroundColor(.black)
            }
            .foregroundColor(.blue)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal, 12)
       
        
    }
}



enum DestinationScreen: Hashable {
    case myTrips, paymentMethod,
         discount, profile, news, aboutApp
}
