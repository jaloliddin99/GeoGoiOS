//
//  ProfileScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/10/24.
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var languageViewModel = LanguageViewModel()

    var body: some View {
        ZStack{
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
                            Text("txt_application_language")
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
                Spacer()
                
            }
        }
        .sheet(isPresented: $languageViewModel.showLanguageSheet, content: {
            BottomSheet{
                DialogLanguage(languageViewModel: languageViewModel)
            }
        })
        .background(.white)
        .navigationTitle("txt_profile")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        
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
