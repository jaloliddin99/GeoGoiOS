//
//  TermsOfUseAndPPScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 21/08/24.
//

import SwiftUI

struct TermsOfUseAndPPScreen: View{
    let url: String

    var body: some View {
        WebView(url: url)
            .ignoresSafeArea()
    }
}
