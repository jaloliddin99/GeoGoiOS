//
//  ProfileScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/10/24.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject var languageViewModel = LanguageViewModel()
    
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var navigateToAccessScreen = false

    var body: some View {
        ZStack{
            
            NavigationLink(destination: AccessScreen(), isActive: $navigateToAccessScreen) {
                EmptyView()
            }
            .hidden()

            
            VStack{
                ProfileImageView(viewModel: viewModel)
                    .padding(.bottom, 12)
                
                Divider()
                
                
                Button {
                    languageViewModel.showLanguageSheet = true
                } label: {
                    HStack(){
                        Image(systemName: "globe")
                        VStack(alignment: .leading){
                            Text("txt_application_language".localize())
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.txt)
                            
                            Text("\(languageViewModel.selectedLanguage)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.txt)
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.forward")
                        
                    }
                }
                Divider()
                Spacer()
                
                Button {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        Text("log_out".localize())
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.txt)
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

               
                Button {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.xmark")
                        Text("delete_profile_account".localize())
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.txt)
                    }
                    .foregroundColor(.red.opacity(0.8))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.bottom, 12)
                
                
            }
        }
        .sheet(isPresented: $languageViewModel.showLanguageSheet, content: {
            BottomSheet {
                DialogLanguage(vm: languageViewModel)
            }
        })
        
        .navigationDestination(isPresented: Binding<Bool>(
            get: { viewModel.isProfileDeleted != nil },
            set: { _ in }
        )) {
            if let isProfileDeleted = viewModel.isProfileDeleted {
                if isProfileDeleted {
                    AccessScreen()
                }
            }
        }
        .background(.white)
        .navigationTitle("txt_profile".localize())
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .alert("confirm_logout_title".localize(), isPresented: $showLogoutAlert) {
            
            Button("confirm_button".localize(), role: .destructive) {
                UserDefaults.standard.setValue(false, forKey: Constants.isUserLoggedIn)
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    UserDefaults.standard.synchronize()
                }
                navigateToAccessScreen.toggle()
                
            }
            Button("cancel_button".localize(), role: .cancel) { }
        }
        .alert("confirm_delete_title".localize(), isPresented: $showDeleteAlert) {
            Button("confirm_button".localize(), role: .destructive) {
                viewModel.deleteProfile()
            }
            Button("cancel_button".localize(), role: .cancel) { }
        }
        .alert(item: $viewModel.alertItem, content: createAlert)
        
    }
    
    private func createAlert(alertItem: AlertItem) -> Alert {
        Alert(title: alertItem.title,
              message: alertItem.message,
              dismissButton: alertItem.dismissButton)
    }

    
    
    func ProfileImageView(viewModel: MainViewModel) -> some View{
        VStack(alignment: .center){
            let baseUrl = UserDefaults.standard.value(forKey: Constants.baseUrl)!
            let userName = UserDefaults.standard.string(forKey: Constants.USER_NAME)!
            let url = "\(baseUrl)/bosh/get_photo.php?type=client&phone="
            let finalUrl = "\(url)\(getUserPhone())"
            
            HStack{
                Spacer()
                ZStack{
                    RemoteRoundedImage(image: viewModel.image, radius: 48, imageName: "profile-image")
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 54)
                                .stroke(.main, lineWidth: 2)
                        )
                        .onAppear { viewModel.loadImage(fromURLString: finalUrl) }
                    
                    Image(systemName: "pencil")
                    
                }
                
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

}
