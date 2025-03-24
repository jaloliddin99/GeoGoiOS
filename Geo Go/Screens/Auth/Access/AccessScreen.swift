//
//  AccessScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/06/24.
//

import SwiftUI
import CoreLocation
import UserNotifications


struct AccessScreen: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = AccessViewModel()

    let txtGivePermission: LocalizedStringKey = "txt_give_permission"
    let navigationService: LocalizedStringKey = "txt_using_navigation_service"
    let gps: LocalizedStringKey = "gps"
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    PermissionView(
                        imageName: "gps_map",
                        title: gps,
                        description: navigationService)

                    Button{
                        locationManager.requestLocation()
                    }label: {
                        GGButton(title: LocalizedStringKey("allow"))
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .padding()
            .onReceive(locationManager.$location) { location in
                guard let location = location else { return }
                let coor = location.coordinate
                viewModel.getAppetizer(lat: coor.latitude, lon: coor.longitude)
            
            }
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton
                )
            }
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.postData != nil },
                set: { _ in
                    viewModel.postData = nil
}
            )){
                if viewModel.postData != nil {
                    AddNameScreen()
                }
            }
        }
        
        
    }
    
}



struct PermissionView: View {
    let imageName: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 12){
            Spacer()
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
            
            Spacer()
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.system(size: 20))
                .fontWeight(.regular)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 56)
    }
}

//
//#Preview {
//    AccessScreen()
//}
