//
//  AboutAppScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct AboutAppScreen: View {
    @State private var bUrl: String = (UserDefaults.standard.value(forKey: Constants.userUrl) as? String) ?? "https://geogo.uz"
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80, maxHeight: 80)
                
                Text("Version - V1.0.1")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 20)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundColor(Color(.secondarySystemBackground).opacity(0.5))
                    .padding(.top, 20)
                
                NavigationLink(destination: TermsOfUseAndPPScreen(url: termsOfUse(lang: DataHolder.lang, url: bUrl))) {
                    HStack {
                        Text("Terms of Use")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                }
                
                Divider()
                
                NavigationLink(destination: TermsOfUseAndPPScreen(url: privacyPolicyUrl(lang: DataHolder.lang, url: bUrl))) {
                    HStack {
                        Text("Privacy Policy")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                }
                
                Spacer()
                
                Text("« Geo Go™ »")
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 16)
            .background(.white)
            .navigationTitle("About App")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
