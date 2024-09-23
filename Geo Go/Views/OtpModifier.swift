//
//  OtpModifier.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 19/09/24.
//

import SwiftUI
import Combine

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    var textLimit = 1
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 40, height: 48)
            .font(.system(size: 14))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}
